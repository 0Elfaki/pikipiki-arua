import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_model.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  Future<void> sendOtp(String phoneNumber) async {
    await _supabase.auth.signInWithOtp(phone: phoneNumber);
  }

  Future<AuthResponse> verifyOtp(String phoneNumber, String token) async {
    return await _supabase.auth.verifyOTP(
      phone: phoneNumber,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<AppUser?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      return AppUser(
        id: user.id,
        phoneNumber: user.phone ?? '',
        fullName: 'Arua Commuter',
      );
    }
    return AppUser.fromJson(response);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
