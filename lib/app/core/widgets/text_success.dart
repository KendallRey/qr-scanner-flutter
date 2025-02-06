import 'package:flutter/material.dart';

class TextSuccessWidget extends StatelessWidget {
  final String text;
  const TextSuccessWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Theme.of(context).primaryColor));
  }
}
