part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  final String eventName;
  final String description;
  final EventType? eventType;
  final String? eventNameError;
  final String? descriptionError;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final String? eventDateError;

  const CreateEventState({
    this.eventName = '',
    this.description = '',
    this.eventType = EventType.text_party,
    this.eventNameError,
    this.descriptionError,
    this.eventDate,
    this.eventTime,
    this.eventDateError,
  });

  CreateEventState copyWith({
    String? eventName,
    String? description,
    EventType? eventType,
    String? eventNameError,
    String? descriptionError,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? eventDateError,
    bool clearDate = false,
    bool clearTime = false,
    bool clearDateError = false,
  }) {
    return CreateEventState(
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      eventNameError: eventNameError,
      descriptionError: descriptionError,
      eventDate: clearDate ? null : (eventDate ?? this.eventDate),
      eventTime: clearTime ? null : (eventTime ?? this.eventTime),
      eventDateError: clearDateError ? null : (eventDateError ?? this.eventDateError),
    );
  }

  @override
  List<Object?> get props => [eventName, description, eventType, eventNameError, descriptionError, eventDate, eventTime, eventDateError];
}
