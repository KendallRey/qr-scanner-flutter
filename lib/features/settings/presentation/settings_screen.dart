import 'package:flutter/material.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';

class SettingsScreenWidget extends StatefulWidget {
  const SettingsScreenWidget({super.key});

  @override
  State<SettingsScreenWidget> createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  void _handleFlushHive() {
    ScanItemService.flushScanItems();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
          onPressed: _handleFlushHive, child: Text('Clear Saved Data')),
    );
  }
}
