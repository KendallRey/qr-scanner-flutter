import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/app/core/model/scan_item.dart';
import 'package:qr_scanner/app/core/widgets/dialog.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  List<dynamic> scannedItems = [];

  String? _uri;

  @override
  void initState() {
    super.initState();
    _getAllScannedItems();
  }

  void _getAllScannedItems() async {
    final savedScannedItems = await ScanItemService.getAllScannedItems();
    setState(() {
      scannedItems = savedScannedItems;
    });
  }

  void _handleDeleteItem(String id) async {
    ScanItemService.deleteScanItem(id);
    _getAllScannedItems();
    if (mounted) {
      context.pop(true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Item deleted...')));
    }
  }

  Future<bool?> _showDeleteItemDialog(ScanItem item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Item ?'),
            content: Text(item.id),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () => _handleDeleteItem(item.id),
                child: Text('Delete'),
              ),
            ],
          );
        });
  }

  void _handleClose() {
    if (mounted) {
      context.pop(false);
      setState(() {
        _uri = null;
      });
    }
  }

  void _handleOpen(String? uri) {
    if (mounted && uri != null) {
      context.pop(true);
      setState(() {
        _uri = null;
      });
      _parseOpenBarcode(uri);
    }
  }

  Future<void> _parseOpenBarcode(String? uri) async {
    AppHelper.parseOpenBarcode(context, uri);
  }

  Future<bool?> _showOpenScanItemDialog(String? text) async {
    return AppHelper.showScanItemDialog(context, text, actions: [
      TextButton(
        onPressed: _handleClose, // Cancel
        child: Text('Close'),
      ),
      ElevatedButton(
        onPressed: () => _handleOpen(text),
        child: Text('Open'),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: scannedItems.length,
            itemBuilder: (context, index) {
              final item = scannedItems[index];
              return ListTile(
                title: GestureDetector(
                  onTap: () => _showOpenScanItemDialog(item.id),
                  child: Text(item.id ?? ':ID:'),
                ),
                subtitle: Text(item.createdAt ?? 'No Date'),
                trailing: IconButton(
                  onPressed: () => _showDeleteItemDialog(item),
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
                shape: BorderDirectional(
                    bottom: BorderSide(color: Theme.of(context).dividerColor)),
              );
            },
          )
        ],
      ),
    );
  }
}
