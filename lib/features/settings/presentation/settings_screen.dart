import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';
import 'package:qr_scanner/app/core/providers/app_settings_provider.dart';
import 'package:qr_scanner/app/core/utils/helper.dart';
import 'package:qr_scanner/app/core/widgets/checkbox_form.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';
import 'package:provider/provider.dart';

class SettingsScreenWidget extends StatefulWidget {
  const SettingsScreenWidget({super.key});

  @override
  State<SettingsScreenWidget> createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  bool hasCameraPermission = true;

  @override
  void initState() {
    super.initState();
    _checkHasCameraPermission();
  }

  void _checkHasCameraPermission() async {
    final hasPermission = await AppHelper.getHasCameraPermission();
    setState(() {
      hasCameraPermission = hasPermission;
    });
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
        child: Stack(children: [
          Column(
            children: [
              Column(
                children: [
                  CheckboxForm(
                      key: Key(Keys.checkboxSaveOnDetect),
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
              SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Text(
                    "Supported schemes:",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("HTTPS",
                          style: Theme.of(context).textTheme.labelMedium),
                      Text("- Opens web links in a browser",
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("SMS",
                          style: Theme.of(context).textTheme.labelMedium),
                      Text(
                          "- Launches the messaging app with a pre-filled number.",
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("TEL",
                          style: Theme.of(context).textTheme.labelMedium),
                      Text("- Opens the phone dialer with a specified number.",
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (!hasCameraPermission)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () => AppHelper.requestCameraPermission(context),
                child: Text('Ask Camera Permission'),
              ),
            )
        ]));
  }
}
