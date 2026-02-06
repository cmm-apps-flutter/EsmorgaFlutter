import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaRadiobutton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;

  const EsmorgaRadiobutton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            RadioGroup<bool>(
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              child: Radio<bool>(
                value: true,
                side: BorderSide(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: EsmorgaText(
                style: EsmorgaTextStyle.body1,
                text: text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
