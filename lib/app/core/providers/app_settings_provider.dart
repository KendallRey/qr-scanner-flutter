import 'package:flutter/material.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider with ChangeNotifier {
  late SharedPreferences preferences;

  bool _settingsSaveOnDetect = false;
  bool get settingsSaveOnDetect => _settingsSaveOnDetect;

  AppSettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    preferences = await SharedPreferences.getInstance();
    _loadProviderSettings();
  }

  Future<void> _loadProviderSettings() async {
    _settingsSaveOnDetect =
        preferences.getBool(Constants.settingsSaveOnDetect) ?? false;
    notifyListeners();
  }

  void toggleSaveOnDetect() {
    _settingsSaveOnDetect = !_settingsSaveOnDetect;
    notifyListeners();
    preferences.setBool(Constants.settingsSaveOnDetect, _settingsSaveOnDetect);
  }
}
