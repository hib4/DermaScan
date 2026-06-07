import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/network/api_config.dart';
import 'package:dermascan/core/services/storage_provider.dart';

class AuthService {
  final ApiClient _apiClient;
  final StorageProvider _storage;

  AuthService({required ApiClient apiClient, required StorageProvider storage})
      : _apiClient = apiClient,
        _storage = storage;

  Future<void> register({required String name, required String email, required String password}) async {
    final resp = await _apiClient.post(
      ApiConfig.register,
      {'name': name, 'email': email, 'password': password},
    );
    await _storage.setToken((resp as Map<String, dynamic>)['access_token'] as String);
  }

  Future<void> login({required String email, required String password}) async {
    final resp = await _apiClient.postForm(
      ApiConfig.login,
      {'email': email, 'password': password},
    );
    await _storage.setToken((resp as Map<String, dynamic>)['access_token'] as String);
  }

  Future<void> logout() async => await _storage.deleteToken();

  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }
}
