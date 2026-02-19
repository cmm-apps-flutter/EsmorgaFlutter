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
    return TimePickerDialog(
      initialTime: initialTime,
      helpText: selectTimeHelpText,
      confirmText: confirmButtonText,
      cancelText: dismissButtonText,
      initialEntryMode: TimePickerEntryMode.dial,
    );
  }
}