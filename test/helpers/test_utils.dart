import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';

/// Provides a ready-to-use English localizations instance for tests.
AppLocalizationsEn testL10n() => AppLocalizationsEn();

/// Real validator instance wired with English strings.
FormValidator testValidator() => FormValidator();

/// Fake date formatter for predictable UI mapping in tests.
class FakeDateFormatter implements EsmorgaDateTimeFormatter {
  const FakeDateFormatter();

  @override
  String formatEventDate(int epochMillis) => 'eventDate';

  @override
  String formatIsoDateTime(DateTime date, String time) => 'iso';

  @override
  String formatTimeWithMillisUtcSuffix(int hour, int minute) => 'timeZ';
}

/// Ensures a singleton FakeDateFormatter is registered.
void ensureFakeDateFormatter() {
  if (!getIt.isRegistered<EsmorgaDateTimeFormatter>()) {
    getIt.registerSingleton<EsmorgaDateTimeFormatter>(const FakeDateFormatter());
  }
}
