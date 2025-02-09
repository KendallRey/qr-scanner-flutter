import 'package:flutter/material.dart';

class ListLabel extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool isLoading;
  const ListLabel(
      {super.key, this.icon, required this.label, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: 64),
        if (isLoading) CircularProgressIndicator(),
        if (icon != null || isLoading) SizedBox(height: 24),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        )
      ],
    );
  }
}
