import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_file_log/simple_file_log.dart';

class MyLogFlutter with MyLogMixin {
  MyLogFlutter._();

  static final MyLogFlutter _instance = MyLogFlutter._();

  static MyLogFlutter get log => _instance;

  String? _logFile;

  @override
  String? get logFile => _logFile;

  @override
  Future<Logger> init({bool? debug, int days = 3}) async {
    final myDebug = debug ?? kDebugMode;

    final logFile = await getLogFile(myDebug, days: days);
    _logFile = logFile;
    return MyLog.init(
      level: myDebug ? Level.ALL : Level.INFO,
      logFile: File(logFile),
      append: !myDebug,
      consoleLog: (time, msg) =>
          myDebug ? debugPrint('$time $msg') : debugPrint(msg),
    );
  }

  @override
  Future<String> getLogFile(bool debug, {int days = 3}) async {
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

    String savePath = '$tempPath/${dateFormatYMD.format(dateTime)}.log';
    final daysLog = <String>[savePath];
    for (int i = (days - 1); i > 0; i--) {
      String tmpPath =
          '$tempPath/${dateFormatYMD.format(dateTime.subtract(Duration(days: i)))}.log';
      daysLog.add(tmpPath);
    }

    // 清理文件
    var files = tmpDir.listSync();
    for (final file in files) {
      if (!daysLog.contains(file.path)) {
        file.deleteSync();
      }
    }

    return savePath;
  }
}
