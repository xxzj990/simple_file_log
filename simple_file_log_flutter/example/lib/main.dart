import 'package:flutter/material.dart';
import 'package:simple_file_log_flutter/simple_file_log_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  (await MyLogFlutter.log.init(days: 2)).info('app start...');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with LogUtil {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              logger.fine('test log0:${DateTime.now()}');
              MyLogFlutter.log.dispose();
              logger.fine('test log1:${DateTime.now()}');
              (await MyLogFlutter.log.init()).info('app start2...');
              logger.fine('test log2:${DateTime.now()}');
              try {
                const tt = '';
                tt.substring(5);
              } catch (e, s) {
                logger.severe('err test', e, s);
              }
            },
            child: const Text('Test Log'),
          ),
        ),
      ),
    );
  }
}
