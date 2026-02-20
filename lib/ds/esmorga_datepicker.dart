import 'package:flutter/material.dart';

class EsmorgaDatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime? currentDate;
  final ValueChanged<DateTime> onDateChanged;

  const EsmorgaDatePicker({
    super.key,
    this.initialDate,
    this.currentDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveNow = currentDate ?? DateTime.now();
    final startOfToday = DateTime(effectiveNow.year, effectiveNow.month, effectiveNow.day);
    final baseDate = initialDate ?? effectiveNow;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: CalendarDatePicker(
        initialDate: baseDate,
        currentDate: effectiveNow,
        firstDate: startOfToday,
        lastDate: DateTime(baseDate.year + 100, 12, 31),
        onDateChanged: onDateChanged,
        selectableDayPredicate: (DateTime day) {
          return !day.isBefore(startOfToday);
        },
      ),
    );
  }
}
