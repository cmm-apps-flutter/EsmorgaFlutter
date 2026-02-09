import 'package:flutter/material.dart';

class EsmorgaTimePickerDialog extends StatelessWidget {
  final TimeOfDay initialTime;
  final String confirmButtonText;
  final String dismissButtonText;
  final String selectTimeHelpText;

  const EsmorgaTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.confirmButtonText,
    required this.dismissButtonText,
    required this.selectTimeHelpText,
  });

  static Future<void> show({
    required BuildContext context,
    required TimeOfDay initialTime,
    required String confirmButtonText,
    required String dismissButtonText,
    required String selectTimeHelpText,
    required ValueChanged<TimeOfDay> onTimeSelected,
  }) async {
    final selectedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (dialogContext) => EsmorgaTimePickerDialog(
        initialTime: initialTime,
        confirmButtonText: confirmButtonText,
        dismissButtonText: dismissButtonText,
        selectTimeHelpText: selectTimeHelpText,
      ),
    );
    if (selectedTime != null) {
      onTimeSelected(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final actionButtonBorderRadius = BorderRadius.circular(8.0);

    return Theme(
      data: Theme.of(context).copyWith(
        timePickerTheme: TimePickerThemeData(
          backgroundColor: colorScheme.surface,
          padding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          hourMinuteShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          hourMinuteColor: WidgetStateColor.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest;
          }),
          hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface;
          }),
          hourMinuteTextStyle: textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          dayPeriodShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          dayPeriodColor: WidgetStateColor.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colorScheme.tertiaryContainer
                : colorScheme.surfaceContainerHighest;
          }),
          dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colorScheme.onTertiaryContainer
                : colorScheme.onSurface;
          }),
          dayPeriodBorderSide: BorderSide.none,
          dialBackgroundColor: colorScheme.surfaceContainerHighest,
          dialHandColor: colorScheme.primary,
          dialTextColor: WidgetStateColor.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colorScheme.onPrimary
                : colorScheme.onSurface;
          }),
          cancelButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(colorScheme.secondary),
            foregroundColor: WidgetStateProperty.all(colorScheme.onSecondary),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: actionButtonBorderRadius),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          confirmButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(colorScheme.primary),
            foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: actionButtonBorderRadius),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: const Size(120, 48),
          ),
        ),
      ),
      child: TimePickerDialog(
        initialTime: initialTime,
        helpText: selectTimeHelpText,
        confirmText: confirmButtonText,
        cancelText: dismissButtonText,
        initialEntryMode: TimePickerEntryMode.dial,
      ),
    );
  }
}