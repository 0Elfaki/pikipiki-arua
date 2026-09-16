class IncomingTripRequest {
  final String tripId;
  final String riderName;
  final String riderPhone;
  final String pickupStage;
  final double pickupLat;
  final double pickupLng;
  final String dropoffAddress;
  final double dropoffLat;
  final double dropoffLng;
  final double fareUgx;
  final String paymentMethod;
  final double distanceToPickupKm;
  final int countdownSeconds;

  const IncomingTripRequest({
    required this.tripId,
    required this.riderName,
    required this.riderPhone,
    required this.pickupStage,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.fareUgx,
    required this.paymentMethod,
    required this.distanceToPickupKm,
    this.countdownSeconds = 25,
  });
}

enum DriverTripStatus {
  idle,
  incoming,
  accepted,
  arrivedAtPickup,
  tripInProgress,
  completed,
}
