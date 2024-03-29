import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

typedef ConsoleLog = void Function(String time, String msg);

const _logTagMain = 'main';

abstract class MyLog {
  static IOSink? _sink;

  static StreamSubscription? _sub;

  static Logger init({
    Level level = Level.ALL,
    File? logFile,
    bool append = true,
    ConsoleLog? consoleLog,
  }) {
    if (logFile != null) {
      _sink = logFile.openWrite(
        mode: append ? FileMode.writeOnlyAppend : FileMode.writeOnly,
      );

      _sink?.writeln('');
      _sink?.writeln('===========start log===========');
    }

    Logger.root.level = level;
    _sub = Logger.root.onRecord.listen((record) {
      final time = '${record.time}:';
      final msg = '${record.level.name}: '
          '${record.loggerName}: '
          '${record.message}'
          '${record.error != null ? '\n${record.error}' : ''}'
          '${record.stackTrace != null ? '\n${record.stackTrace}' : ''}';

      final line = '$time $msg';

      if (consoleLog == null) {
        stdout.writeln(line);
      } else {
        consoleLog.call(time, msg);
      }

      _sink?.writeln(line);
    });

    return getLogger();
  }

  static Future<void> dispose() async {
    Logger.root.clearListeners();
    _sub?.cancel();
    await _sink?.close();
    _sink = null;
  }

  static Future<void> flush() async {
    await _sink?.flush();
  }

  static void setLevel(Level level) {
    Logger.root.level = level;
  }

  static Level getLevel() => Logger.root.level;

  static Logger getLogger({String? name}) => Logger(name ?? _logTagMain);

  /// json 格式化
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static String prettyJson(data) => _encoder.convert(data);
}
