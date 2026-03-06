import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';

export 'package:esmorga_flutter/domain/event/model/event_type.dart';

extension EventTypeLocalizedName on EventType {
  String localizedName(AppLocalizations l10n) => switch (this) {
    EventType.party => l10n.createEventTypeParty,
    EventType.sport => l10n.createEventTypeSport,
    EventType.food => l10n.createEventTypeFood,
    EventType.charity => l10n.createEventTypeCharity,
    EventType.games => l10n.createEventTypeGames,
  };
}
