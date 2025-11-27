import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaCheckboxRow extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const EsmorgaCheckboxRow({
    super.key,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: EsmorgaText(
                text: text,
                style: EsmorgaTextStyle.body1,
              ),
            ),
            const SizedBox(width: 8),
            Checkbox(
              value: isSelected,
              onChanged: onTap != null ? (_) => onTap!() : null,
            ),
          ],
        ),
      ),
    );
  }
}
