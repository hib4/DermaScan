class ApiConfig {
  ApiConfig._();

  static String get baseUrl => 'https://dermascan.hib4.me';

  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String scans = '/api/scans';
}
