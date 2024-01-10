import 'package:logging/logging.dart';

import 'mylog_dart.dart';

mixin LogUtil {
  String get tag => '$runtimeType';

  Logger get logger => MyLogDart.log.getLogger(name: tag);
}
