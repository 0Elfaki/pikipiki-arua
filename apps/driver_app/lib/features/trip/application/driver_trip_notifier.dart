import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final String? dispatchMessage;

  const DriverTripState({
    this.status = DriverTripStatus.idle,
    this.incomingRequest,
    this.currentLatitude = 3.0303,
    this.currentLongitude = 30.9073,
    this.todayEarningsUgx = 28500.0,
    this.completedTripsToday = 9,
    this.dispatchMessage,
  });

  DriverTripState copyWith({
    DriverTripStatus? status,
    IncomingTripRequest? incomingRequest,
    bool clearIncomingRequest = false,
    double? currentLatitude,
    double? currentLongitude,
    double? todayEarningsUgx,
    int? completedTripsToday,
    String? dispatchMessage,
  }) {
    return DriverTripState(
      status: status ?? this.status,
      incomingRequest:
          clearIncomingRequest ? null : (incomingRequest ?? this.incomingRequest),
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      todayEarningsUgx: todayEarningsUgx ?? this.todayEarningsUgx,
      completedTripsToday: completedTripsToday ?? this.completedTripsToday,
      dispatchMessage: dispatchMessage,
    );
  }
}

class DriverTripNotifier extends StateNotifier<DriverTripState> {
  final DriverTripRepository _repository;
  RealtimeChannel? _offersChannel;
  String? _driverId;

  DriverTripNotifier(this._repository) : super(const DriverTripState());

  /// Starts listening for real dispatch offers for [driverId]. Call this
  /// whenever the driver goes online; call [stopListening] on going offline.
  Future<void> startListening(String driverId) async {
    _driverId = driverId;

    final pending = await _repository.fetchPendingOffer(driverId);
    if (pending != null) {
      state = state.copyWith(
        status: DriverTripStatus.incoming,
        incomingRequest: pending,
      );
    }

    _offersChannel?.unsubscribe();
    _offersChannel = _repository.subscribeToOffers(
      driverId: driverId,
      onChange: (request) {
        if (request != null) {
          state = state.copyWith(
            status: DriverTripStatus.incoming,
            incomingRequest: request,
          );
        } else if (state.status == DriverTripStatus.incoming) {
          // Offer was withdrawn (taken/expired elsewhere) before we responded.
          state = state.copyWith(
            status: DriverTripStatus.idle,
            clearIncomingRequest: true,
          );
        }
      },
    );
  }

  void stopListening() {
    _offersChannel?.unsubscribe();
    _offersChannel = null;
    _driverId = null;
  }

  Future<void> acceptTrip() async {
    final request = state.incomingRequest;
    final driverId = _driverId;
    if (request == null || driverId == null) return;

    final result = await _repository.respondToTrip(
      tripId: request.tripId,
      driverId: driverId,
      action: 'accept',
    );

    if (result != null && result['status'] == 'accepted') {
      state = state.copyWith(status: DriverTripStatus.accepted);
    } else {
      // Someone else took it, or it expired server-side in the meantime.
      state = state.copyWith(
        status: DriverTripStatus.idle,
        clearIncomingRequest: true,
        dispatchMessage: 'That request is no longer available.',
      );
    }
  }

  Future<void> rejectTrip() async {
    final request = state.incomingRequest;
    final driverId = _driverId;
    state = state.copyWith(status: DriverTripStatus.idle, clearIncomingRequest: true);
    if (request == null || driverId == null) return;
    await _repository.respondToTrip(
      tripId: request.tripId,
      driverId: driverId,
      action: 'decline',
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
      clearIncomingRequest: true,
    );
  }

  void resetToIdle() {
    state = state.copyWith(status: DriverTripStatus.idle);
  }

  @override
  void dispose() {
    _offersChannel?.unsubscribe();
    super.dispose();
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
