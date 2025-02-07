import 'package:flutter/material.dart';
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
}
