import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/storage_provider.dart';
import 'api_config.dart';

class ApiClient {
  final http.Client _client;
  final StorageProvider _storage;

  ApiClient({http.Client? client, required StorageProvider storage})
      : _client = client ?? http.Client(),
        _storage = storage;

  String get baseUrl => ApiConfig.baseUrl;

  Future<Map<String, String>> _headers({Map<String, String>? extra}) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (extra != null) headers.addAll(extra);
    final token = await _storage.getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers();
    final response = await _client.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers(extra: {'Content-Type': 'application/json'});
    final response = await _client.post(uri, headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> postForm(String path, Map<String, String> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers();
    final response = await _client.post(uri, headers: headers, body: body);
    return _handleResponse(response);
  }

  Future<dynamic> postMultipart(
    String path,
    String filePath, {
    required Map<String, String> fields,
    String fileField = 'image',
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers();
    headers.remove('Content-Type');

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath(fileField, filePath));

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    final body = _safeDecode(response.body);
    final message = body?['detail'] ?? 'Request failed: ${response.statusCode}';
    switch (response.statusCode) {
      case 401:
        throw AuthException(message);
      case 409:
        throw ConflictException(message);
      case >= 500:
        throw ServerException(message);
      default:
        throw ApiException(message, response.statusCode);
    }
  }

  dynamic _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, [this.statusCode]);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class AuthException extends ApiException {
  const AuthException(super.message);
}

class ConflictException extends ApiException {
  const ConflictException(super.message);
}

class ServerException extends ApiException {
  const ServerException(super.message);
}
