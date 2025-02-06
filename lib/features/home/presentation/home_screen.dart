import 'package:flutter/material.dart';
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
                title: item.id,
                subtitle: Text(item.createdAt ?? 'No Date'),
              );
            },
          )
        ],
      ),
    );
  }
}
