import 'package:flutter/material.dart';
import 'package:simple_file_log_flutter/simple_file_log_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  (await MyLogFlutter.instance.init()).info('app start...');
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
            onPressed: () {
              logger.fine('test log:${DateTime.now()}');
            },
            child: const Text('Test Log'),
          ),
        ),
      ),
    );
  }
}
