import 'package:simple_file_log/simple_file_log.dart';

void main() async {
  (await MyLogDart.log.init(debug: true, days: 2)).info('app start...');

  final myClassA = MyClassA();
  myClassA.testLog();

  MyLogDart.log.dispose();

  myClassA.testLog();

  (await MyLogDart.log.init(debug: true)).info('app start2...');

  myClassA.testLog();

  myClassA.testErr();
}

class MyClassA with LogUtil {
  void testLog() {
    logger.fine('testLog');
  }

  void testErr() {
    try {
      final test = '';
      test.substring(5);
    } catch (e, s) {
      logger.severe('test err', e, s);
    }
  }
}
