import 'package:logger/logger.dart';

/// Centralized logger for DermaScan.
///
/// Usage: `AppLogger.scan.d('message')`, `AppLogger.scan.e('error', error: e, stackTrace: st)`
class AppLogger {
  AppLogger._();

  /// Scan flow logger — camera, inference, image processing, backend sync.
  static final scan = Logger(
    printer: _DermaScanPrinter(tag: 'Scan'),
    level: Level.trace,
  );

  /// Auth flow logger — login, register, token management.
  static final auth = Logger(
    printer: _DermaScanPrinter(tag: 'Auth'),
    level: Level.trace,
  );

  /// API / network logger — HTTP requests, responses, errors.
  static final api = Logger(
    printer: _DermaScanPrinter(tag: 'API'),
    level: Level.trace,
  );

  /// General / misc logger.
  static final app = Logger(
    printer: _DermaScanPrinter(tag: 'App'),
    level: Level.trace,
  );
}

class _DermaScanPrinter extends LogPrinter {
  _DermaScanPrinter({this.tag = 'DermaScan'});

  final String tag;

  static const _levelIcons = {
    Level.trace: '┃',
    Level.debug: '┣',
    Level.info: '┣',
    Level.warning: '┣⚠',
    Level.error: '┣✗',
    Level.fatal: '┗',
  };

  @override
  List<String> log(LogEvent event) {
    final icon = _levelIcons[event.level] ?? '┃';
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);

    final lines = <String>[];
    final header = '$timestamp $icon [$tag] ${event.message}';
    lines.add(header);

    if (event.error != null) {
      lines.add('┃   Error: ${event.error}');
    }
    if (event.stackTrace != null) {
      final st = event.stackTrace.toString();
      final stLines = st.split('\n');
      final toShow = stLines.length > 6 ? stLines.sublist(0, 6) : stLines;
      for (final line in toShow) {
        lines.add('┃   $line');
      }
      if (stLines.length > 6) {
        lines.add('┃   ... (${stLines.length - 6} more frames)');
      }
    }

    return lines;
  }
}
