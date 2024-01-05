import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import 'mylog.dart';

final DateFormat _dateFormatYMD = DateFormat("yyyy-MM-dd");

abstract class MyLogDart {
  static Future<Logger> init({
    bool debug = false,
  }) async {
    final logFile = await _getLogFile(debug);
    return MyLog.init(
      level: debug ? Level.ALL : Level.INFO,
      logFile: File(logFile),
      append: !debug,
    );
  }

  static void flush() => MyLog.flush();

  static void setLevel(Level level) => MyLog.setLevel(level);

  static Level getLevel() => MyLog.getLevel();

  static Logger getLogger({String? name}) => MyLog.getLogger(name: name);

  static String prettyJson(data) => MyLog.prettyJson(data);

  static Future<String> _getLogFile(bool debug) async {
    DateTime dateTime = DateTime.now();
    final String tempPath;
    if (debug) {
      tempPath = 'data${path.separator}log';
    } else {
      tempPath = '${path.separator}log';
    }
    Directory tmpDir = Directory(tempPath);
    if (!tmpDir.existsSync()) {
      tmpDir.createSync();
    }

    String prePath =
        '$tempPath/${_dateFormatYMD.format(dateTime.subtract(const Duration(days: 1)))}.log';
    String savePath = '$tempPath/${_dateFormatYMD.format(dateTime)}.log';

    // 清理文件(保存最近2天日志)
    var files = tmpDir.listSync();
    for (var file in files) {
      if (file.path != savePath && file.path != prePath) {
        file.deleteSync();
      }
    }

    return savePath;
  }
}
