import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';

class SettingsScreenWidget extends StatefulWidget {
  const SettingsScreenWidget({super.key});

  @override
  State<SettingsScreenWidget> createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> {
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
    return Center(
      child: OutlinedButton(
          onPressed: _showDeleteAllDialog, child: Text('Clear Saved Data')),
    );
  }
}
