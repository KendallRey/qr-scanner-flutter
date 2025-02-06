import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextCopy extends StatelessWidget {
  final String text;
  final bool? disable;
  const TextCopy({super.key, required this.text, this.disable});

  void _onTap(BuildContext ctx) {
    if (ctx.mounted) {
      if (disable == true) return;
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Text(text),
    );
  }
}
