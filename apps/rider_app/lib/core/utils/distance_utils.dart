import 'dart:math' as math;

class DistanceUtils {
  /// Calculates great-circle distance between two coordinates in kilometers (Haversine formula)
  static double calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double p = 0.017453292519943295; // Pi / 180
    final double a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Calculates base fare in UGX for Arua City
  /// Base fare: 2,000 UGX + 800 UGX / km
  static double calculateBodaFareUGX(double distanceKm) {
    const double baseFare = 2000.0;
    const double perKmRate = 800.0;
    final double rawFare = baseFare + (distanceKm * perKmRate);
    // Round to nearest 500 UGX
    return (rawFare / 500).ceil() * 500.0;
  }
}
