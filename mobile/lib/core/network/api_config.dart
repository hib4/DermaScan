import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  ApiConfig._();

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    if (Platform.isIOS) return 'http://localhost:8000';
    return 'http://10.0.2.2:8000';
  }

  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String scans = '/api/scans';
}
