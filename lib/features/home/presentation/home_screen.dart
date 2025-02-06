import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/core/model/scan_item.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  List<dynamic> scannedItems = [];

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
                title: Text(item.id ?? ':ID:'),
                subtitle: Text(item.createdAt ?? 'No Date'),
                trailing: IconButton(
                  onPressed: () => _showDeleteItemDialog(item),
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
