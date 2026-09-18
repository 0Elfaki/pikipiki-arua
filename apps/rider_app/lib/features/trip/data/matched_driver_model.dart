class MatchedDriver {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String numberPlate;
  final String motorcycleModel;
  final double rating;
  final int totalTrips;

  const MatchedDriver({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.numberPlate,
    required this.motorcycleModel,
    required this.rating,
    required this.totalTrips,
  });

  factory MatchedDriver.fromRows(
    Map<String, dynamic> driverRow,
    Map<String, dynamic>? profileRow,
  ) {
    return MatchedDriver(
      id: driverRow['id'] as String,
      fullName: profileRow?['full_name'] as String? ?? 'Boda Driver',
      phoneNumber: profileRow?['phone_number'] as String? ?? '',
      numberPlate: driverRow['number_plate'] as String? ?? '',
      motorcycleModel:
          driverRow['motorcycle_make_model'] as String? ?? 'Boda Motorcycle',
      rating: (profileRow?['rating'] as num?)?.toDouble() ?? 5.0,
      totalTrips: (driverRow['total_trips'] as num?)?.toInt() ?? 0,
    );
  }
}
