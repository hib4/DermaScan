import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
    print('[API] GET $uri');
    final response = await _client.get(uri, headers: headers);
    return _handleResponse(path, response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers(extra: {'Content-Type': 'application/json'});
    print('[API] POST $uri  body=${jsonEncode(body)}');
    final response = await _client.post(uri, headers: headers, body: jsonEncode(body));
    return _handleResponse(path, response);
  }

  Future<dynamic> postForm(String path, Map<String, String> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers();
    print('[API] POST(FORM) $uri  body=$body');
    final response = await _client.post(uri, headers: headers, body: body);
    return _handleResponse(path, response);
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

    final contentType = _guessContentType(filePath);
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.add(
      await http.MultipartFile.fromPath(
        fileField,
        filePath,
        contentType: contentType != null ? MediaType.parse(contentType) : null,
      ),
    );

    print('[API] POST(MULTIPART) $uri  fields=$fields  file=$filePath');
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(path, response);
  }

  String _extractMessage(dynamic body, int statusCode) {
    if (body == null) return 'Request failed: $statusCode';
    final detail = body['detail'];
    if (detail is String) return detail;
    if (detail is List) {
      final messages = detail.whereType<Map>().map((e) {
        final loc = (e['loc'] as List?)?.join('.') ?? '';
        final msg = e['msg'] as String? ?? '';
        return '$loc: $msg';
      }).join('; ');
      if (messages.isNotEmpty) return messages;
    }
    return 'Request failed: $statusCode';
  }

  dynamic _handleResponse(String path, http.Response response) {
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    if (isSuccess) {
      print('[API] ${response.statusCode} $path  body=${response.body}');
    } else {
      print('[API] ERROR ${response.statusCode} $path  body=${response.body}');
    }

    if (isSuccess) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    final body = _safeDecode(response.body);
    final message = _extractMessage(body, response.statusCode);
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

  String? _guessContentType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'heic':
      case 'heif':
        return 'image/heic';
      default:
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
