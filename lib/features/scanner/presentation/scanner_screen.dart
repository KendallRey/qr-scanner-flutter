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
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 64),
          child: ScannerWindow(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('Align the QR Code in the camera'),
          ),
        )
      ],
    );
  }
}
