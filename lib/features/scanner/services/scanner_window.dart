import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
      _showOpenScannedDialog(captured.barcodes.firstOrNull);
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
      _makePhoneCall(barcode.rawValue);
    }
  }

  Future<void> _makePhoneCall(String? uri) async {
    if (uri == null) return;
    final Uri? launchUri = Uri.tryParse(uri);
    if (launchUri == null) return;
    await launchUrl(launchUri);
  }

  Future<bool?> _showOpenScannedDialog(Barcode? _barcode) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('QR Code'),
            content: Text(_barcode?.displayValue ?? 'Failed to read QR!'),
            actions: [
              TextButton(
                onPressed: _handleClose, // Cancel
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () => _handleOpen(_barcode),
                child: Text('Open'),
              ),
            ],
          );
        });
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
