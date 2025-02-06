import 'package:flutter/material.dart';

class TextErrorWidget extends StatelessWidget {
  final String text;
  const TextErrorWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Theme.of(context).primaryColor));
  }
}
