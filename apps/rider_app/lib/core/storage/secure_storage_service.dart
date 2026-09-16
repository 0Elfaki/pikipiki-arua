import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'auth_jwt_token';
  static const _userIdKey = 'user_id';
  static const _userPhoneKey = 'user_phone';

  Future<void> saveAuthSession({
    required String token,
    required String userId,
    required String phone,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _userPhoneKey, value: phone);
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<String?> getUserId() => _storage.read(key: _userIdKey);
  Future<String?> getUserPhone() => _storage.read(key: _userPhoneKey);

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userPhoneKey);
  }
}
