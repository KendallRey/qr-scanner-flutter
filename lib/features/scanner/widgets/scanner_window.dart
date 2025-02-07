import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/core/model/scan_item.dart';
import 'package:qr_scanner/app/core/utils/helper.dart';
import 'package:qr_scanner/app/core/widgets/text_error.dart';
import 'package:qr_scanner/app/core/widgets/text_success.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';

class BarcodeScannerWithScanWindow extends StatefulWidget {
  const BarcodeScannerWithScanWindow({super.key});

  @override
  State<BarcodeScannerWithScanWindow> createState() =>
      _BarcodeScannerWithScanWindowState();
}

class _BarcodeScannerWithScanWindowState
    extends State<BarcodeScannerWithScanWindow> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
  );

  Barcode? _barcode;

  void _handleOnDetect(BarcodeCapture captured) {
    if (mounted && _barcode == null) {
      setState(() {
        _barcode = captured.barcodes.firstOrNull;
      });
      final barcode = captured.barcodes.firstOrNull;
      _saveAsScanItem(barcode);
      _showOpenScannedDialog(barcode);
    }
  }

  void _saveAsScanItem(Barcode? barcode) {
    if (barcode == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: TextErrorWidget(
          text: "Error: Can't read QR Code!",
        )));
      }
      return;
    }
    if (barcode.rawValue != null) {
      final scanItem = ScanItem.create(barcode.rawValue!);
      ScanItemService.saveScanItem(scanItem);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: TextSuccessWidget(
        text: "QR Saved!",
      )));
    }
  }

  void _handleClose() {
    if (mounted) {
      context.pop(false);
      setState(() {
        _barcode = null;
      });
    }
  }

  void _handleOpen(Barcode? barcode) {
    if (mounted && barcode != null) {
      context.pop(true);
      setState(() {
        _barcode = null;
      });
      _parseOpenBarcode(barcode.rawValue);
    }
  }

  Future<void> _parseOpenBarcode(String? uri) async {
    AppHelper.parseOpenBarcode(context, uri);
  }

  Future<bool?> _showOpenScannedDialog(Barcode? barcode) async {
    return AppHelper.showScanItemDialog(context, barcode?.displayValue,
        actions: [
          TextButton(
            onPressed: _handleClose, // Cancel
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => _handleOpen(barcode),
            child: Text('Open'),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: MobileScanner(
      controller: controller,
      onDetect: _handleOnDetect,
    ));
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
