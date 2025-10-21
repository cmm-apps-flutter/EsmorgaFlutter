enum EventType {
  party,
  sport,
  food,
  charity,
  games,
}

extension EventTypeExtension on EventType {
  static EventType fromString(String value) {
    try {
      switch (value.toLowerCase()) {
        case 'party':
          return EventType.party;
        case 'sport':
          return EventType.sport;
        case 'food':
          return EventType.food;
        case 'charity':
          return EventType.charity;
        case 'games':
          return EventType.games;
        default:
          return EventType.party;
      }
    } catch (e) {
      return EventType.party;
    }
  }

  String toJson() {
    switch (this) {
      case EventType.party:
        return 'party';
      case EventType.sport:
        return 'sport';
      case EventType.food:
        return 'food';
      case EventType.charity:
        return 'charity';
      case EventType.games:
        return 'games';
    }
  }
}

