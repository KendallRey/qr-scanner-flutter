import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/core/widgets/text_copy.dart';
import 'package:qr_scanner/app/core/widgets/text_error.dart';
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
      _parseOpenBarcode(barcode.rawValue);
    }
  }

  Future<void> _parseOpenBarcode(String? uri) async {
    try {
      if (mounted) {
        if (uri == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextErrorWidget(
            text: "Error: Invalid QR Code!",
          )));
          return;
        }
        final Uri? launchUri = Uri.tryParse(uri);
        if (launchUri == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextErrorWidget(
            text: "Error: Failed to Read URI!",
          )));
          return;
        }
        await launchUrl(launchUri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: TextErrorWidget(
          text: "Error: Failed to Launch!",
        )));
      }
    }
  }

  Future<bool?> _showOpenScannedDialog(Barcode? barcode) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('QR Code'),
            content: TextCopy(
              text: barcode?.displayValue ?? 'Failed to read QR!',
              disable: barcode == null,
            ),
            actions: [
              TextButton(
                onPressed: _handleClose, // Cancel
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () => _handleOpen(barcode),
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
