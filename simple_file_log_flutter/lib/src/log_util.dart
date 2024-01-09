import 'package:logging/logging.dart';
import 'package:simple_file_log_flutter/simple_file_log_flutter.dart';

mixin LogUtil {
  String get tag => '$runtimeType';

  Logger get logger => MyLogFlutter.instance.getLogger(name: tag);
}
