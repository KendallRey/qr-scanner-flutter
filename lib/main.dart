import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:qr_scanner/app/app.dart';
import 'package:qr_scanner/app/observers/app_life.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final path = Directory.current.path;
  Hive.init(path);
  runApp(AppLifecycleObserver(child: MyApp()));
}
