library simplefilelog;

export 'src/log_util.dart';
export 'src/mylog_dart.dart'
    if(dart.library.ui) 'src/mylog_flutter.dart';
