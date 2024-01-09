import 'package:logging/logging.dart';

import 'mylog_dart.dart' if (dart.library.ui) 'mylog_flutter.dart';

mixin LogUtil {
  String get tag => '$runtimeType';

  Logger get logger => MyLogProxy.getLogger(name: tag);
}
