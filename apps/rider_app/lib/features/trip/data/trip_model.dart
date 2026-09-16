class BodaStage {
  final String id;
  final String name;
  final String code;
  final String chairmanName;
  final double latitude;
  final double longitude;

  const BodaStage({
    required this.id,
    required this.name,
    required this.code,
    required this.chairmanName,
    required this.latitude,
    required this.longitude,
  });

  factory BodaStage.fromJson(Map<String, dynamic> json) {
    return BodaStage(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      chairmanName: json['chairman_name'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class Trip {
  final String id;
  final String riderId;
  final String? driverId;
  final String status;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String dropoffAddress;
  final double dropoffLat;
  final double dropoffLng;
  final double fareUgx;
  final String paymentMethod;
  final DateTime createdAt;

  const Trip({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.status,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.fareUgx,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      riderId: json['rider_id'] as String,
      driverId: json['driver_id'] as String?,
      status: json['status'] as String? ?? 'requested',
      pickupAddress: json['pickup_address'] as String,
      pickupLat: (json['pickup_latitude'] as num).toDouble(),
      pickupLng: (json['pickup_longitude'] as num).toDouble(),
      dropoffAddress: json['dropoff_address'] as String,
      dropoffLat: (json['dropoff_latitude'] as num).toDouble(),
      dropoffLng: (json['dropoff_longitude'] as num).toDouble(),
      fareUgx: (json['fare_ugx'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String? ?? 'cash',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
