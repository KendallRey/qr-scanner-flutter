import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/app/app.dart';
import 'package:qr_scanner/app/core/model/scan_item.dart';
import 'package:qr_scanner/app/core/providers/app_settings_provider.dart';
import 'package:qr_scanner/app/observers/app_life.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  final path = appDocumentsDir.path;
  Hive.init(path);
  Hive
    ..init(path)
    ..registerAdapter(ScanItemAdapter());
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppSettingsProvider())],
      child: AppLifecycleObserver(child: MyApp())));
}
