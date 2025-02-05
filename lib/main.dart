import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_scanner/app/app.dart';
import 'package:qr_scanner/app/observers/app_life.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(AppLifecycleObserver(child: MyApp()));
}
