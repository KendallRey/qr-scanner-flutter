import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/app/core/utils/helper.dart';

class ScannerErrorWidget extends StatelessWidget {
  final VoidCallback onPermissionGranted;
  const ScannerErrorWidget(
      {super.key, required this.error, required this.onPermissionGranted});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
    }

    void requestCameraPermission() async {
      final isGranted = await AppHelper.requestCameraPermission(context);
      if (isGranted == true) {
        onPermissionGranted();
      }
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            if (error.errorCode == MobileScannerErrorCode.permissionDenied)
              ElevatedButton(
                onPressed: () => requestCameraPermission(),
                child: Text('Ask Camera Permission'),
              )
          ],
        ),
      ),
    );
  }
}
