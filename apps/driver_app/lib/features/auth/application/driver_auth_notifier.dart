import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/driver_model.dart';

class DriverAuthState {
  final bool isLoading;
  final DriverProfile? driver;
  final bool isOnline;
  final String? errorMessage;

  const DriverAuthState({
    this.isLoading = false,
    this.driver,
    this.isOnline = false,
    this.errorMessage,
  });

  DriverAuthState copyWith({
    bool? isLoading,
    DriverProfile? driver,
    bool? isOnline,
    String? errorMessage,
  }) {
    return DriverAuthState(
      isLoading: isLoading ?? this.isLoading,
      driver: driver ?? this.driver,
      isOnline: isOnline ?? this.isOnline,
      errorMessage: errorMessage,
    );
  }
}

class DriverAuthNotifier extends StateNotifier<DriverAuthState> {
  DriverAuthNotifier()
      : super(
          const DriverAuthState(
            driver: DriverProfile(
              id: 'driver-arua-01',
              fullName: 'Juma Bosco Ondoma',
              phoneNumber: '+256 772 445 566',
              stageName: 'Arua Hill Roundabout Stage',
              numberPlate: 'UFL 492X',
            ),
          ),
        );

  void toggleOnlineStatus() {
    final newStatus = !state.isOnline;
    state = state.copyWith(
      isOnline: newStatus,
      driver: state.driver?.copyWith(isOnline: newStatus),
    );
  }

  void signOut() {
    state = const DriverAuthState();
  }
}

final driverAuthNotifierProvider =
    StateNotifierProvider<DriverAuthNotifier, DriverAuthState>((ref) {
  return DriverAuthNotifier();
});
