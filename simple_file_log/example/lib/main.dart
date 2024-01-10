import 'package:simple_file_log/simple_file_log.dart';

void main() async {
  (await MyLogDart.log.init(debug: true)).info('app start...');

  final myClassA = MyClassA();
  myClassA.testLog();

  MyLogDart.log.dispose();

  myClassA.testLog();

  (await MyLogDart.log.init(debug: true)).info('app start2...');

  myClassA.testLog();
}

class MyClassA with LogUtil {
  void testLog() {
    logger.fine('testLog');
  }
}
