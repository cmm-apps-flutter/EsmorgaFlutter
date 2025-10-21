import 'package:flutter/widgets.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';

class LocalizationService {
  AppLocalizations? _current;

  Future<void> load(Locale locale) async {
    _current = await AppLocalizations.delegate.load(locale);
  }

  AppLocalizations get current {
    if (_current == null) {
      throw Exception('Localizations not loaded. Call load() first.');
    }
    return _current!;
  }
}
