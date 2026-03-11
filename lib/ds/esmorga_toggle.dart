import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaToggle extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const EsmorgaToggle({
    super.key,
    required this.text,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onChanged(!isEnabled),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: EsmorgaText(
                text: text,
                style: EsmorgaTextStyle.heading2,
                maxLines: 2,
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: null,
              activeTrackColor: colorScheme.primary,
              activeThumbColor: colorScheme.onPrimary,
              inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.35),
              inactiveThumbColor: colorScheme.onPrimary,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }
}
