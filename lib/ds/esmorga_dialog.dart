import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaDialog extends StatelessWidget {
  final String title;
  final String confirmButtonText;
  final String dismissButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  const EsmorgaDialog({
    super.key,
    required this.title,
    required this.confirmButtonText,
    required this.dismissButtonText,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 32.0,
          bottom: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: EsmorgaText(
                text: title,
                style: EsmorgaTextStyle.body1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: EsmorgaButton(
                      text: dismissButtonText,
                      onClick: onDismiss,
                      oneLine: true,
                      primary: false,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: EsmorgaButton(
                      text: confirmButtonText,
                      onClick: onConfirm,
                      oneLine: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

