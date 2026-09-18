import 'package:supabase_flutter/supabase_flutter.dart';
import 'driver_trip_model.dart';

class DriverTripRepository {
  final SupabaseClient _supabase;

  DriverTripRepository(this._supabase);

  /// Sets this driver's online/offline status (and optionally position) via
  /// the driver-presence Edge Function. Routed through a service-role
  /// function rather than a direct table update because the driver app
  /// currently runs against a fixed demo identity with no real Supabase Auth
  /// session, so the `drivers` table's RLS update policy would otherwise
  /// reject a direct client write.
  Future<Map<String, dynamic>?> setOnlineStatus({
    required String driverId,
    required bool isOnline,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'driver-presence',
        body: {
          'driver_id': driverId,
          'is_online': isOnline,
          'latitude': ?latitude,
          'longitude': ?longitude,
        },
      );
      return response.data as Map<String, dynamic>?;
    } catch (_) {
      // Handled via offline sync queue when connectivity drops
      return null;
    }
  }

  Future<void> updateDriverLocation({
    required String driverId,
    required double lat,
    required double lng,
  }) async {
    try {
      await _supabase.functions.invoke(
        'driver-presence',
        body: {'driver_id': driverId, 'latitude': lat, 'longitude': lng},
      );
    } catch (_) {
      // Handled via offline sync queue when connectivity drops
    }
  }

  /// Fetches the trip currently offered to this driver (status = 'searching'
  /// and driver_id = this driver), if any. Used when first going online, as
  /// a fallback alongside the realtime subscription below.
  Future<IncomingTripRequest?> fetchPendingOffer(String driverId) async {
    try {
      final row = await _supabase
          .from('trips')
          .select()
          .eq('driver_id', driverId)
          .eq('status', 'searching')
          .order('requested_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) return null;
      return await _toIncomingRequest(row);
    } catch (_) {
      return null;
    }
  }

  /// Subscribes to trips assigned to this driver so a new dispatch offer
  /// (status flips to 'searching') is picked up in realtime, and clears the
  /// incoming card if the offer is withdrawn before this driver responds.
  RealtimeChannel subscribeToOffers({
    required String driverId,
    required void Function(IncomingTripRequest? request) onChange,
  }) {
    final channel = _supabase.channel('driver-offers-$driverId');
    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'trips',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'driver_id',
            value: driverId,
          ),
          callback: (payload) {
            final row = payload.newRecord;
            if (row.isEmpty) return;
            if (row['status'] == 'searching') {
              _toIncomingRequest(row).then(onChange);
            } else {
              onChange(null);
            }
          },
        )
        .subscribe();
    return channel;
  }

  Future<IncomingTripRequest> _toIncomingRequest(Map<String, dynamic> row) async {
    String riderName = 'Arua Rider';
    String riderPhone = '';
    final riderId = row['rider_id'] as String?;
    if (riderId != null) {
      try {
        final profile = await _supabase
            .from('profiles')
            .select('full_name, phone_number')
            .eq('id', riderId)
            .maybeSingle();
        if (profile != null) {
          riderName = profile['full_name'] as String? ?? riderName;
          riderPhone = profile['phone_number'] as String? ?? '';
        }
      } catch (_) {
        // Fall back to placeholder rider identity above.
      }
    }

    return IncomingTripRequest(
      tripId: row['id'] as String,
      riderName: riderName,
      riderPhone: riderPhone,
      pickupStage: row['pickup_address'] as String? ?? 'Pickup Stage',
      pickupLat: (row['pickup_latitude'] as num).toDouble(),
      pickupLng: (row['pickup_longitude'] as num).toDouble(),
      dropoffAddress: row['dropoff_address'] as String? ?? 'Destination',
      dropoffLat: (row['dropoff_latitude'] as num).toDouble(),
      dropoffLng: (row['dropoff_longitude'] as num).toDouble(),
      fareUgx: (row['fare_ugx'] as num).toDouble(),
      paymentMethod: row['payment_method'] as String? ?? 'cash',
      distanceToPickupKm: 0,
    );
  }

  /// Accepts or declines/times-out the currently offered trip via the
  /// dispatch-respond Edge Function. On decline/timeout the matching engine
  /// immediately re-offers the trip to the next-nearest driver server-side.
  Future<Map<String, dynamic>?> respondToTrip({
    required String tripId,
    required String driverId,
    required String action, // 'accept' | 'decline' | 'timeout'
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'dispatch-respond',
        body: {'trip_id': tripId, 'driver_id': driverId, 'action': action},
      );
      return response.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }
}
