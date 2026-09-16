import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'driver_jwt_token';
  static const _driverIdKey = 'driver_id';

  Future<void> saveDriverSession({
    required String token,
    required String driverId,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _driverIdKey, value: driverId);
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<String?> getDriverId() => _storage.read(key: _driverIdKey);

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _driverIdKey);
  }
}
