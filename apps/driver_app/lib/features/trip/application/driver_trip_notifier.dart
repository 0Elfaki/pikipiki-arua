import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/driver_trip_model.dart';
import '../data/driver_trip_repository.dart';
import '../../../app/providers.dart';

class DriverTripState {
  final DriverTripStatus status;
  final IncomingTripRequest? incomingRequest;
  final double currentLatitude;
  final double currentLongitude;
  final double todayEarningsUgx;
  final int completedTripsToday;

  const DriverTripState({
    this.status = DriverTripStatus.idle,
    this.incomingRequest,
    this.currentLatitude = 3.0303,
    this.currentLongitude = 30.9073,
    this.todayEarningsUgx = 28500.0,
    this.completedTripsToday = 9,
  });

  DriverTripState copyWith({
    DriverTripStatus? status,
    IncomingTripRequest? incomingRequest,
    double? currentLatitude,
    double? currentLongitude,
    double? todayEarningsUgx,
    int? completedTripsToday,
  }) {
    return DriverTripState(
      status: status ?? this.status,
      incomingRequest: incomingRequest,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      todayEarningsUgx: todayEarningsUgx ?? this.todayEarningsUgx,
      completedTripsToday: completedTripsToday ?? this.completedTripsToday,
    );
  }
}

class DriverTripNotifier extends StateNotifier<DriverTripState> {
  final DriverTripRepository _repository;

  DriverTripNotifier(this._repository) : super(const DriverTripState());

  void simulateIncomingRide() {
    final req = _repository.getDemoIncomingRequest();
    state = state.copyWith(
      status: DriverTripStatus.incoming,
      incomingRequest: req,
    );
  }

  void acceptTrip() {
    state = state.copyWith(status: DriverTripStatus.accepted);
  }

  void rejectTrip() {
    state = state.copyWith(
      status: DriverTripStatus.idle,
      incomingRequest: null,
    );
  }

  void arrivedAtPickup() {
    state = state.copyWith(status: DriverTripStatus.arrivedAtPickup);
  }

  void startTrip() {
    state = state.copyWith(status: DriverTripStatus.tripInProgress);
  }

  void completeTrip() {
    final fare = state.incomingRequest?.fareUgx ?? 3000;
    state = state.copyWith(
      status: DriverTripStatus.completed,
      todayEarningsUgx: state.todayEarningsUgx + fare,
      completedTripsToday: state.completedTripsToday + 1,
      incomingRequest: null,
    );
  }

  void resetToIdle() {
    state = state.copyWith(status: DriverTripStatus.idle);
  }
}

final driverTripRepositoryProvider = Provider<DriverTripRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DriverTripRepository(client);
});

final driverTripNotifierProvider =
    StateNotifierProvider<DriverTripNotifier, DriverTripState>((ref) {
  final repo = ref.watch(driverTripRepositoryProvider);
  return DriverTripNotifier(repo);
});
