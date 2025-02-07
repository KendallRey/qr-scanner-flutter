import 'package:flutter/material.dart';

class CheckboxForm extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;
  final String label;
  const CheckboxForm(
      {super.key,
      required this.value,
      this.onChanged,
      required this.label,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [Checkbox(value: value, onChanged: onChanged), Text(label)],
      ),
    );
  }
}
