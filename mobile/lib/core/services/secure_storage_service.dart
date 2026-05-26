import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_provider.dart';

class SecureStorageService implements StorageProvider {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyToken = 'jwt_token';

  @override
  Future<String?> getToken() => _storage.read(key: _keyToken);

  @override
  Future<void> setToken(String token) => _storage.write(key: _keyToken, value: token);

  @override
  Future<void> deleteToken() => _storage.delete(key: _keyToken);
}
