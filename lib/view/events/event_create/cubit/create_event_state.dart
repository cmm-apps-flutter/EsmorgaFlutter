part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  final String eventName;
  final String description;
  final EventType? eventType;
  final String? eventNameError;
  final String? descriptionError;

  const CreateEventState({
    this.eventName = '',
    this.description = '',
    this.eventType = EventType.text_party,
    this.eventNameError,
    this.descriptionError,
  });

  CreateEventState copyWith({
    String? eventName,
    String? description,
    EventType? eventType,
    String? eventNameError,
    String? descriptionError,
  }) {
    return CreateEventState(
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      eventNameError: eventNameError,
      descriptionError: descriptionError,
    );
  }

  @override
  List<Object?> get props => [eventName, description, eventType, eventNameError, descriptionError];
}
