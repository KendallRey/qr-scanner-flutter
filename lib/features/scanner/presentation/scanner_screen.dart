import 'package:flutter/material.dart';
import 'package:qr_scanner/features/scanner/widgets/scanner_window.dart';

class ScannerScreenWidget extends StatefulWidget {
  const ScannerScreenWidget({super.key});

  @override
  State<ScannerScreenWidget> createState() => _ScannerScreenWidgetState();
}

class _ScannerScreenWidgetState extends State<ScannerScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: BarcodeScannerWithScanWindow(),
    );
  }
}
