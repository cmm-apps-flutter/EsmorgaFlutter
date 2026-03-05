import 'package:esmorga_flutter/domain/event/model/create_event_params.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';

class CreateEventUseCase {
  final EventRepository _eventRepository;

  CreateEventUseCase(this._eventRepository);

  Future<void> execute(CreateEventParams eventData) async {
    await _eventRepository.createEvent(eventData);
  }
}
