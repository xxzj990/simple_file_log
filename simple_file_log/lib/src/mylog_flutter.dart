import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_file_log/src/mylog.dart';

final DateFormat _dateFormatYMD = DateFormat("yyyy-MM-dd");

abstract class MyLogProxy {
  static String? _logFile;

  static String? get logFile => _logFile;

  static Future<Logger> init() async {
    final logFile = await _getLogFile();
    _logFile = logFile;
    return MyLog.init(
      level: kDebugMode ? Level.ALL : Level.INFO,
      logFile: File(logFile),
      append: !kDebugMode,
      consoleLog: (time, msg) =>
          kDebugMode ? debugPrint('$time $msg') : debugPrint(msg),
    );
  }

  static void flush() => MyLog.flush();

  static void setLevel(Level level) => MyLog.setLevel(level);

  static Level getLevel() => MyLog.getLevel();

  static Logger getLogger({String? name}) => MyLog.getLogger(name: name);

  static String prettyJson(data) => MyLog.prettyJson(data);

  static Future<String> _getLogFile() async {
    Directory? tempDir;
    if (Platform.isIOS) {
      tempDir = await getApplicationDocumentsDirectory();
    } else {
      tempDir = await getExternalStorageDirectory();
    }
    DateTime dateTime = DateTime.now();
    String tempPath = '${tempDir!.path}/log';
    Directory tmpDir = Directory(tempPath);
    if (!tmpDir.existsSync()) {
      tmpDir.createSync();
    }

    String savePath = '$tempPath/${_dateFormatYMD.format(dateTime)}.log';

    // 清理文件
    var files = tmpDir.listSync();
    for (var file in files) {
      if (file.path != savePath) {
        file.deleteSync();
      }
    }

    return savePath;
  }
}
