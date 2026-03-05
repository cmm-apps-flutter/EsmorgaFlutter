import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';

export 'package:esmorga_flutter/domain/event/model/event_type.dart';

extension EventTypeLocalizedName on EventType {
  String localizedName(AppLocalizations l10n) => switch (this) {
    EventType.party => l10n.step2OptionParty,
    EventType.sport => l10n.step2OptionSport,
    EventType.food => l10n.step2OptionFood,
    EventType.charity => l10n.step2OptionCharity,
    EventType.games => l10n.step2OptionGames,
  };
}
