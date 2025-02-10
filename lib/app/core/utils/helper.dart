import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/app/core/widgets/text_copy.dart';
import 'package:qr_scanner/app/core/widgets/text_error.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHelper {
  static Future<bool?> showScanItemDialog(BuildContext ctx, String? text,
      {actions = List<Widget>}) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text('QR Code'),
            content: TextCopy(
              text: text ?? 'Failed to read QR!',
              disable: text == null,
            ),
            actions: actions,
          );
        });
  }

  static Future<void> parseOpenBarcode(BuildContext ctx, String? uri) async {
    try {
      if (ctx.mounted) {
        if (uri == null) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: TextErrorWidget(
            text: "Error: Invalid QR Code!",
          )));
          return;
        }
        final Uri? launchUri = Uri.tryParse(uri);
        if (launchUri == null) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: TextErrorWidget(
            text: "Error: Failed to Read URI!",
          )));
          return;
        }
        await launchUrl(launchUri);
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: TextErrorWidget(
          text: "Error: Failed to Launch!",
        )));
      }
    }
  }

  static Future<bool?> _showRequestCameraPermissionDialog(
      BuildContext ctx) async {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text('Permission Required'),
            content: Text(
                "Camera access is required. Please enable it in settings."),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop(true);
                  openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          );
        });
  }

  static Future<bool?> requestCameraPermission(BuildContext ctx) async {
    if (ctx.mounted) {
      PermissionStatus status = await Permission.camera.status;

      if (status.isDenied) {
        status = await Permission.camera.request();
      }
      if ((status.isDenied || !status.isGranted) && ctx.mounted) {
        return _showRequestCameraPermissionDialog(ctx);
      } else if (status.isGranted && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text("Camera permission granted!")),
        );
        return true;
      } else if (status.isPermanentlyDenied && ctx.mounted) {
        return _showRequestCameraPermissionDialog(ctx);
      }
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Camera permission denied.")),
      );
      return false;
    }
    return false;
  }

  static Future<bool> getHasCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    return status.isGranted;
  }
}
