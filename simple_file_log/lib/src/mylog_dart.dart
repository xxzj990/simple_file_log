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
  Future<Logger> init({bool? debug, int days = 3}) async {
    final myDebug = debug ?? false;

    final logFile = await getLogFile(myDebug, days: days);
    _logFile = logFile;
    return MyLog.init(
      level: myDebug ? Level.ALL : Level.INFO,
      logFile: File(logFile),
      append: !myDebug,
    );
  }

  @override
  Future<String> getLogFile(bool debug, {int days = 3}) async {
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

    String savePath = '$tempPath/${dateFormatYMD.format(dateTime)}.log';
    final daysLog = <String>[savePath];
    for (int i = (days - 1); i > 0; i--) {
      String tmpPath =
          '$tempPath/${dateFormatYMD.format(dateTime.subtract(Duration(days: i)))}.log';
      daysLog.add(tmpPath);
    }

    var files = tmpDir.listSync();
    for (final file in files) {
      if (!daysLog.contains(file.path)) {
        file.deleteSync();
      }
    }

    return savePath;
  }
}

mixin MyLogMixin {
  String? get logFile;

  DateFormat get dateFormatYMD => DateFormat("yyyy-MM-dd");

  Future<Logger> init({bool debug = false, int days = 3});

  Future<String> getLogFile(bool debug, {int days = 3});

  void dispose() => MyLog.dispose();

  void flush() => MyLog.flush();

  void setLevel(Level level) => MyLog.setLevel(level);

  Level getLevel() => MyLog.getLevel();

  Logger getLogger({String? name}) => MyLog.getLogger(name: name);

  String prettyJson(data) => MyLog.prettyJson(data);
}
