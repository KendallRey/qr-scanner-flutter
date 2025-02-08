import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/app/core/model/scan_item.dart';
import 'package:qr_scanner/app/core/providers/app_settings_provider.dart';
import 'package:qr_scanner/app/core/utils/helper.dart';
import 'package:qr_scanner/app/core/widgets/text_error.dart';
import 'package:qr_scanner/app/core/widgets/text_success.dart';
import 'package:qr_scanner/app/services/scan_item_service.dart';
import 'package:qr_scanner/features/scanner/widgets/scanner_error_widget.dart';

class ScannerWindow extends StatefulWidget {
  const ScannerWindow({super.key});

  @override
  State<ScannerWindow> createState() => _ScannerWindowState();
}

class _ScannerWindowState extends State<ScannerWindow> {
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
    if (mounted) {
      if (barcode == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: TextErrorWidget(
          text: "Error: Can't read QR Code!",
        )));
        return;
      }
      final saveOnDetect =
          Provider.of<AppSettingsProvider>(context, listen: false)
              .settingsSaveOnDetect;
      if (barcode.rawValue != null && saveOnDetect) {
        final scanItem = ScanItem.create(barcode.rawValue!);
        ScanItemService.saveScanItem(scanItem);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: TextSuccessWidget(
          text: "QR Saved!",
        )));
      }
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

  MobileScannerErrorBuilder scannerErrorBuilder =
      (BuildContext ctx, MobileScannerException e, Widget? w) =>
          ScannerErrorWidget(error: e);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MobileScanner(
      fit: BoxFit.cover,
      errorBuilder: scannerErrorBuilder,
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
