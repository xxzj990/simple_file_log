import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import 'mylog.dart';

class MyLogDart with MyLogMixin {
  MyLogDart._();

  static final MyLogDart _instance = MyLogDart._();

  static MyLogDart get log => _instance;

  String? _logFile;

  @override
  String? get logFile => _logFile;

  @override
  Future<Logger> init({bool? debug}) async {
    final myDebug = debug ?? false;

    final logFile = await getLogFile(myDebug);
    _logFile = logFile;
    return MyLog.init(
      level: myDebug ? Level.ALL : Level.INFO,
      logFile: File(logFile),
      append: !myDebug,
    );
  }

  @override
  Future<String> getLogFile(bool debug) async {
    DateTime dateTime = DateTime.now();
    final String tempPath;
    if (debug) {
      tempPath = 'data${path.separator}log';
    } else {
      tempPath = '${path.separator}log';
    }
    Directory tmpDir = Directory(tempPath);
    if (!tmpDir.existsSync()) {
      tmpDir.createSync(recursive: true);
    }

    String prePath =
        '$tempPath/${dateFormatYMD.format(dateTime.subtract(const Duration(days: 1)))}.log';
    String savePath = '$tempPath/${dateFormatYMD.format(dateTime)}.log';

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

mixin MyLogMixin {
  String? get logFile;

  DateFormat get dateFormatYMD => DateFormat("yyyy-MM-dd");

  Future<Logger> init({bool debug = false});

  Future<String> getLogFile(bool debug);

  void dispose() => MyLog.dispose();

  void flush() => MyLog.flush();

  void setLevel(Level level) => MyLog.setLevel(level);

  Level getLevel() => MyLog.getLevel();

  Logger getLogger({String? name}) => MyLog.getLogger(name: name);

  String prettyJson(data) => MyLog.prettyJson(data);
}
