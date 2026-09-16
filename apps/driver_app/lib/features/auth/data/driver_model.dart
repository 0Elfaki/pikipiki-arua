class DriverProfile {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String stageName;
  final String numberPlate;
  final String motorcycleModel;
  final String verificationStatus;
  final bool isOnline;
  final double walletBalanceUgx;
  final int totalTrips;
  final double rating;

  const DriverProfile({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.stageName,
    required this.numberPlate,
    this.motorcycleModel = 'Bajaj Boxer 100 BM',
    this.verificationStatus = 'verified',
    this.isOnline = false,
    this.walletBalanceUgx = 42500.0,
    this.totalTrips = 184,
    this.rating = 4.92,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'Boda Driver',
      phoneNumber: json['phone_number'] as String? ?? '',
      stageName: json['stage_name'] as String? ?? 'Arua Hill Roundabout',
      numberPlate: json['number_plate'] as String? ?? 'UFL 831P',
      motorcycleModel: json['motorcycle_model'] as String? ?? 'Bajaj Boxer 100 BM',
      verificationStatus: json['verification_status'] as String? ?? 'verified',
      isOnline: json['is_online'] as bool? ?? false,
      walletBalanceUgx: (json['wallet_balance_ugx'] as num?)?.toDouble() ?? 42500.0,
      totalTrips: json['total_trips'] as int? ?? 184,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.92,
    );
  }

  DriverProfile copyWith({
    bool? isOnline,
    double? walletBalanceUgx,
    int? totalTrips,
  }) {
    return DriverProfile(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      stageName: stageName,
      numberPlate: numberPlate,
      motorcycleModel: motorcycleModel,
      verificationStatus: verificationStatus,
      isOnline: isOnline ?? this.isOnline,
      walletBalanceUgx: walletBalanceUgx ?? this.walletBalanceUgx,
      totalTrips: totalTrips ?? this.totalTrips,
      rating: rating,
    );
  }
}
