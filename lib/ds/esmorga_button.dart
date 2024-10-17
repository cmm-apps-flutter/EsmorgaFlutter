import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final bool primary;
  final VoidCallback onClick;
  final EdgeInsetsGeometry padding;

  const EsmorgaButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.isEnabled = true,
    this.primary = true,
    required this.onClick,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: primary ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
          disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: primary ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary,
          padding: padding,
        ),
        onPressed: isEnabled && !isLoading ? onClick : null,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    primary ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              )
            : EsmorgaText(
                text: text,
                style: EsmorgaTextStyle.button,
              ),
      ),
    );
  }
}
