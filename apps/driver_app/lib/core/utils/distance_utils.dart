import 'dart:math' as math;

class DistanceUtils {
  static double calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double p = 0.017453292519943295;
    final double a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a));
  }

  static double calculateBodaFareUGX(double distanceKm) {
    const double baseFare = 2000.0;
    const double perKmRate = 800.0;
    final double rawFare = baseFare + (distanceKm * perKmRate);
    return (rawFare / 500).ceil() * 500.0;
  }
}
