import 'package:supabase_flutter/supabase_flutter.dart';
import 'trip_model.dart';

class TripRepository {
  final SupabaseClient _supabase;

  TripRepository(this._supabase);

  // Default Arua City Stages fallback when offline or before remote sync
  static final List<BodaStage> defaultAruaStages = [
    const BodaStage(
      id: 'a1111111-1111-1111-1111-111111111111',
      name: 'Arua Main Market Stage',
      code: 'STAGE-MKT-01',
      chairmanName: 'Bakole Juma',
      latitude: 3.0298,
      longitude: 30.9102,
    ),
    const BodaStage(
      id: 'a2222222-2222-2222-2222-222222222222',
      name: 'Arua Hill Roundabout Stage',
      code: 'STAGE-HILL-02',
      chairmanName: 'Droma Richard',
      latitude: 3.0315,
      longitude: 30.9065,
    ),
    const BodaStage(
      id: 'a3333333-3333-3333-3333-333333333333',
      name: 'Muni University Gate Stage',
      code: 'STAGE-MUNI-03',
      chairmanName: 'Afema Charles',
      latitude: 3.0112,
      longitude: 30.9189,
    ),
    const BodaStage(
      id: 'a4444444-4444-4444-4444-444444444444',
      name: 'Arua Referral Hospital Stage',
      code: 'STAGE-HOSP-04',
      chairmanName: 'Angua Francis',
      latitude: 3.0275,
      longitude: 30.9040,
    ),
    const BodaStage(
      id: 'a5555555-5555-5555-5555-555555555555',
      name: 'Onduparaka Trading Center Stage',
      code: 'STAGE-ONDU-05',
      chairmanName: 'Candia Moses',
      latitude: 3.0450,
      longitude: 30.8920,
    ),
  ];

  Future<List<BodaStage>> fetchStages() async {
    try {
      final response = await _supabase
          .from('boda_stages')
          .select()
          .order('name', ascending: true);
      final list = (response as List<dynamic>)
          .map((e) => BodaStage.fromJson(e as Map<String, dynamic>))
          .toList();
      return list.isNotEmpty ? list : defaultAruaStages;
    } catch (_) {
      return defaultAruaStages;
    }
  }

  Future<Trip> createTripRequest({
    required String riderId,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required String dropoffAddress,
    required double dropoffLat,
    required double dropoffLng,
    required double fareUgx,
    required String paymentMethod,
  }) async {
    final payload = {
      'rider_id': riderId,
      'pickup_address': pickupAddress,
      'pickup_latitude': pickupLat,
      'pickup_longitude': pickupLng,
      'dropoff_address': dropoffAddress,
      'dropoff_latitude': dropoffLat,
      'dropoff_longitude': dropoffLng,
      'fare_ugx': fareUgx,
      'payment_method': paymentMethod,
      'status': 'requested',
    };

    try {
      final res = await _supabase.from('trips').insert(payload).select().single();
      return Trip.fromJson(res);
    } catch (_) {
      // Local fallback for offline mode or demo
      return Trip(
        id: 'offline-demo-${DateTime.now().millisecondsSinceEpoch}',
        riderId: riderId,
        status: 'searching',
        pickupAddress: pickupAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropoffAddress: dropoffAddress,
        dropoffLat: dropoffLat,
        dropoffLng: dropoffLng,
        fareUgx: fareUgx,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      );
    }
  }
}
