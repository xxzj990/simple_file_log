import 'package:simple_file_log/simple_file_log.dart';

void main() async {
  (await MyLogDart.instance.init(debug: true)).info('app start...');

  final myClassA = MyClassA();
  myClassA.testLog();
}

class MyClassA with LogUtil {
  void testLog() {
    logger.fine('testLog');
  }
}
