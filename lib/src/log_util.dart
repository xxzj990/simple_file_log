
import 'package:logging/logging.dart';
import 'package:simple_file_log/src/mylog_flutter.dart';

mixin LogUtil {
  String get tag => '$runtimeType';

  Logger get logger => MyLogFlutter.getLogger(name: tag);
}
