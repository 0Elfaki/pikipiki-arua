import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/driver_model.dart';
import '../../trip/data/driver_trip_repository.dart';
import '../../trip/application/driver_trip_notifier.dart' show driverTripRepositoryProvider;

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
  final DriverTripRepository _tripRepository;

  // Demo boda-operator identity. The id/phone/plate below match a row seeded
  // in backend/supabase/seed.sql (public.drivers), so this demo profile is a
  // real, dispatchable driver in the database - not just local UI state -
  // until phone-OTP auth is wired up in the driver app (mirroring the rider
  // app's real Supabase Auth flow).
  DriverAuthNotifier(this._tripRepository)
      : super(
          const DriverAuthState(
            driver: DriverProfile(
              id: 'd0000000-0000-0000-0000-000000000001',
              fullName: 'Juma Bosco Ondoma',
              phoneNumber: '+256772445566',
              stageName: 'Arua Hill Roundabout Stage',
              numberPlate: 'UFL 492X',
            ),
          ),
        );

  Future<void> toggleOnlineStatus() async {
    final driver = state.driver;
    if (driver == null) return;

    final newStatus = !state.isOnline;
    // Optimistic UI update; the driver-presence call persists it server-side
    // so the matching engine sees this driver as eligible for dispatch.
    state = state.copyWith(
      isOnline: newStatus,
      driver: driver.copyWith(isOnline: newStatus),
    );
    await _tripRepository.setOnlineStatus(driverId: driver.id, isOnline: newStatus);
  }

  void signOut() {
    state = const DriverAuthState();
  }
}

final driverAuthNotifierProvider =
    StateNotifierProvider<DriverAuthNotifier, DriverAuthState>((ref) {
  final tripRepository = ref.watch(driverTripRepositoryProvider);
  return DriverAuthNotifier(tripRepository);
});
