import 'package:esmorga_flutter/view/l10n/app_localizations.dart';

enum EventType {
  text_party,
  text_sport,
  text_food,
  text_charity,
  text_games,
}

extension EventTypeExtension on EventType {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case EventType.text_party:
        return l10n.step2OptionParty;
      case EventType.text_sport:
        return l10n.step2OptionSport;
      case EventType.text_food:
        return l10n.step2OptionFood;
      case EventType.text_charity:
        return l10n.step2OptionCharity;
      case EventType.text_games:
        return l10n.step2OptionGames;
    }
  }
}
