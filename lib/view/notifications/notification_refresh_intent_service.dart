import 'dart:async';

class NotificationRefreshIntentService {
  final _intents = StreamController<void>.broadcast();
  bool _pending = false;
  bool _bound = false;

  Stream<void> get intents => _intents.stream;

  void add() {
    if (_bound) {
      _intents.add(null);
    } else {
      _pending = true;
    }
  }

  void bind() {
    if (_bound) return;
    _bound = true;
    if (_pending) {
      _pending = false;
      _intents.add(null);
    }
  }

  void dispose() => _intents.close();
}