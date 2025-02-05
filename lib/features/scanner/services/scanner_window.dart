import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/app/core/widgets/barcode_overlay.dart';
import 'package:qr_scanner/app/core/widgets/scan_window_overlay.dart';
import 'package:qr_scanner/features/scanner/services/scanned_barcode_label.dart';

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

  // TODO: Fix BoxFit.fill & BoxFit.fitHeight
  final boxFit = BoxFit.contain;

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
      width: 300,
      height: 200,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          fit: boxFit,
          scanWindow: scanWindow,
          controller: controller,
        ),
        BarcodeOverlay(controller: controller, boxFit: boxFit),
        ScanWindowOverlay(
          scanWindow: scanWindow,
          controller: controller,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 100,
            color: const Color.fromRGBO(0, 0, 0, 0.4),
            child: ScannedBarcodeLabel(barcodes: controller.barcodes),
          ),
        ),
      ],
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
