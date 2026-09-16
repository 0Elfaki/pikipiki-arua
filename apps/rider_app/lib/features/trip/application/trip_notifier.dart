import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/trip_model.dart';
import '../data/trip_repository.dart';
import '../../../app/providers.dart';
import '../../../core/utils/distance_utils.dart';

class TripState {
  final bool isLoading;
  final List<BodaStage> stages;
  final BodaStage? selectedPickupStage;
  final BodaStage? selectedDropoffStage;
  final double estimatedFareUgx;
  final Trip? currentTrip;
  final String? errorMessage;

  const TripState({
    this.isLoading = false,
    this.stages = const [],
    this.selectedPickupStage,
    this.selectedDropoffStage,
    this.estimatedFareUgx = 2000.0,
    this.currentTrip,
    this.errorMessage,
  });

  TripState copyWith({
    bool? isLoading,
    List<BodaStage>? stages,
    BodaStage? selectedPickupStage,
    BodaStage? selectedDropoffStage,
    double? estimatedFareUgx,
    Trip? currentTrip,
    String? errorMessage,
  }) {
    return TripState(
      isLoading: isLoading ?? this.isLoading,
      stages: stages ?? this.stages,
      selectedPickupStage: selectedPickupStage ?? this.selectedPickupStage,
      selectedDropoffStage: selectedDropoffStage ?? this.selectedDropoffStage,
      estimatedFareUgx: estimatedFareUgx ?? this.estimatedFareUgx,
      currentTrip: currentTrip ?? this.currentTrip,
      errorMessage: errorMessage,
    );
  }
}

class TripNotifier extends StateNotifier<TripState> {
  final TripRepository _repository;

  TripNotifier(this._repository) : super(const TripState()) {
    loadStages();
  }

  Future<void> loadStages() async {
    state = state.copyWith(isLoading: true);
    final stages = await _repository.fetchStages();
    final pickup = stages.isNotEmpty ? stages[0] : null;
    final dropoff = stages.length > 1 ? stages[1] : null;

    double fare = 2000.0;
    if (pickup != null && dropoff != null) {
      final dist = DistanceUtils.calculateDistanceKm(
        pickup.latitude,
        pickup.longitude,
        dropoff.latitude,
        dropoff.longitude,
      );
      fare = DistanceUtils.calculateBodaFareUGX(dist);
    }

    state = state.copyWith(
      isLoading: false,
      stages: stages,
      selectedPickupStage: pickup,
      selectedDropoffStage: dropoff,
      estimatedFareUgx: fare,
    );
  }

  void selectPickup(BodaStage stage) {
    state = state.copyWith(selectedPickupStage: stage);
    _recalculateFare();
  }

  void selectDropoff(BodaStage stage) {
    state = state.copyWith(selectedDropoffStage: stage);
    _recalculateFare();
  }

  void _recalculateFare() {
    if (state.selectedPickupStage != null && state.selectedDropoffStage != null) {
      final dist = DistanceUtils.calculateDistanceKm(
        state.selectedPickupStage!.latitude,
        state.selectedPickupStage!.longitude,
        state.selectedDropoffStage!.latitude,
        state.selectedDropoffStage!.longitude,
      );
      final fare = DistanceUtils.calculateBodaFareUGX(dist);
      state = state.copyWith(estimatedFareUgx: fare);
    }
  }

  Future<Trip?> requestBodaRide({
    required String riderId,
    String paymentMethod = 'cash',
  }) async {
    if (state.selectedPickupStage == null || state.selectedDropoffStage == null) {
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final trip = await _repository.createTripRequest(
        riderId: riderId,
        pickupAddress: state.selectedPickupStage!.name,
        pickupLat: state.selectedPickupStage!.latitude,
        pickupLng: state.selectedPickupStage!.longitude,
        dropoffAddress: state.selectedDropoffStage!.name,
        dropoffLat: state.selectedDropoffStage!.latitude,
        dropoffLng: state.selectedDropoffStage!.longitude,
        fareUgx: state.estimatedFareUgx,
        paymentMethod: paymentMethod,
      );
      state = state.copyWith(isLoading: false, currentTrip: trip);
      return trip;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  void cancelTrip() {
    state = state.copyWith(currentTrip: null);
  }
}

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TripRepository(client);
});

final tripNotifierProvider =
    StateNotifierProvider<TripNotifier, TripState>((ref) {
  final repo = ref.watch(tripRepositoryProvider);
  return TripNotifier(repo);
});
