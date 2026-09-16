import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../data/user_model.dart';
import '../../../app/providers.dart';

class AuthState {
  final bool isLoading;
  final AppUser? user;
  final String? errorMessage;
  final bool otpSent;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.otpSent = false,
  });

  AuthState copyWith({
    bool? isLoading,
    AppUser? user,
    String? errorMessage,
    bool? otpSent,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      otpSent: otpSent ?? this.otpSent,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.sendOtp(phoneNumber);
      state = state.copyWith(isLoading: false, otpSent: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String token) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.verifyOtp(phoneNumber, token);
      final profile = await _repository.getCurrentUserProfile();
      state = state.copyWith(isLoading: false, user: profile);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> checkSession() async {
    final profile = await _repository.getCurrentUserProfile();
    if (profile != null) {
      state = state.copyWith(user: profile);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
