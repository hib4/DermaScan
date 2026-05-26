abstract class StorageProvider {
  Future<String?> getToken();
  Future<void> setToken(String token);
  Future<void> deleteToken();
}
