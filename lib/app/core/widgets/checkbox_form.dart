import 'package:flutter/material.dart';
import 'package:qr_scanner/app/core/constants/constants.dart';

class CheckboxForm extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;
  final String label;
  const CheckboxForm(
      {super.key = const Key(Keys.checkboxForm),
      required this.value,
      this.onChanged,
      required this.label,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Checkbox(
              key: Key(Keys.checkboxCustom),
              value: value,
              onChanged: onChanged),
          Text(key: Key(Keys.checkboxLabel), label)
        ],
      ),
    );
  }
}
