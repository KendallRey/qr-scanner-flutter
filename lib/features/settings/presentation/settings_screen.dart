import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';
import 'package:qr_scanner/app/core/widgets/checkbox_form.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreenWidget extends StatefulWidget {
  const SettingsScreenWidget({super.key});

  @override
  State<SettingsScreenWidget> createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  bool saveOnDetect = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedSettings();
  }

  // Load remembered settings
  Future<void> _loadRememberedSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final settingsSaveOnDetect =
        preferences.getBool(Constants.settingsSaveOnDetect) ?? false;

    setState(() {
      saveOnDetect = settingsSaveOnDetect;
    });
  }

  void _onTapSaveOnDetect() async {
    final preferences = await SharedPreferences.getInstance();
    final newValue = !saveOnDetect;
    setState(() {
      saveOnDetect = newValue;
    });
    preferences.setBool(Constants.settingsSaveOnDetect, newValue);
  }

  void _handleFlushHive() {
    if (mounted) {
      context.pop(true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All Items deleted...')));
    }
    ScanItemService.flushScanItems();
  }

  Future<bool?> _showDeleteAllDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset ALL'),
            content:
                Text("Are you sure you want to delete all saved QR Codes ?"),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: _handleFlushHive,
                child: Text('Reset'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                CheckboxForm(
                    value: saveOnDetect,
                    label: "Save on detect",
                    onTap: _onTapSaveOnDetect),
              ],
            ),
            SizedBox(height: 32),
            OutlinedButton(
                onPressed: _showDeleteAllDialog,
                child: Text('Clear Saved Data')),
          ],
        ));
  }
}
