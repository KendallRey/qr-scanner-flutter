import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';
import 'package:qr_scanner/app/core/providers/app_settings_provider.dart';
import 'package:qr_scanner/app/core/widgets/checkbox_form.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

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
  }

  void _onTapSaveOnDetect() async {
    if (mounted) {
      context.read<AppSettingsProvider>().toggleSaveOnDetect();
    }
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
                    value: context
                        .watch<AppSettingsProvider>()
                        .settingsSaveOnDetect,
                    label: "Save QR Code after scanning",
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
