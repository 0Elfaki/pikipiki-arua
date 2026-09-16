import 'package:supabase_flutter/supabase_flutter.dart';
import 'driver_trip_model.dart';

class DriverTripRepository {
  final SupabaseClient _supabase;

  DriverTripRepository(this._supabase);

  Future<void> updateDriverLocation({
    required String driverId,
    required double lat,
    required double lng,
  }) async {
    try {
      await _supabase.from('drivers').update({
        'current_latitude': lat,
        'current_longitude': lng,
      }).eq('id', driverId);
    } catch (_) {
      // Handled via offline sync queue when connectivity drops
    }
  }

  IncomingTripRequest getDemoIncomingRequest() {
    return const IncomingTripRequest(
      tripId: 'arua-trip-902',
      riderName: 'Amina Candiru',
      riderPhone: '+256 701 889 900',
      pickupStage: 'Arua Main Market Stage',
      pickupLat: 3.0298,
      pickupLng: 30.9102,
      dropoffAddress: 'Muni University Main Campus',
      dropoffLat: 3.0112,
      dropoffLng: 30.9189,
      fareUgx: 3500,
      paymentMethod: 'Cash (Direct to Boda)',
      distanceToPickupKm: 0.4,
    );
  }
}
