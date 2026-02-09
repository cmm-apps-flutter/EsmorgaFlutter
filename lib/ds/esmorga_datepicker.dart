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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveNow = currentDate ?? DateTime.now();
    final startOfToday = DateTime(effectiveNow.year, effectiveNow.month, effectiveNow.day);
    final baseDate = initialDate ?? effectiveNow;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: colorScheme.copyWith(
            onSurface: colorScheme.onSurfaceVariant,
          ),
          datePickerTheme: DatePickerThemeData(
            headerForegroundColor: colorScheme.onSurfaceVariant,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.onPrimary;
              }
              if (states.contains(WidgetState.disabled)) {
                return colorScheme.onSurface.withValues(alpha: 0.38);
              }
              return colorScheme.onSurface;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primary;
              }
              return colorScheme.surface.withValues(alpha: 0);
            }),
            todayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.onPrimary;
              }
              return colorScheme.primary;
            }),
            todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primary;
              }
              return colorScheme.surface.withValues(alpha: 0);
            }),
            todayBorder: BorderSide(color: colorScheme.primary),
            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.onPrimary;
              }
              return colorScheme.onSurface;
            }),
            yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primary;
              }
              return colorScheme.surface.withValues(alpha: 0);
            }),
            dayStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
            weekdayStyle: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
            ),
            yearStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        child: CalendarDatePicker(
          initialDate: baseDate,
          currentDate: effectiveNow,
          firstDate: startOfToday,
          lastDate: DateTime(baseDate.year + 1, baseDate.month, baseDate.day),
          onDateChanged: onDateChanged,
          selectableDayPredicate: (DateTime day) {
            return !day.isBefore(startOfToday);
          },
        ),
      ),
    );
  }
}
