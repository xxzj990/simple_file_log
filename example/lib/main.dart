import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_file_log/simple_file_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyLogFlutter.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with LogUtil {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    logger.info('123456');
  }

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
              logger.info('log - ${DateTime.now()}');
            },
            child: const Text('Log'),
          ),
        ),
      ),
    );
  }
}
