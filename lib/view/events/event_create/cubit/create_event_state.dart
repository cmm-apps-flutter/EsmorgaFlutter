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
  final String? formattedEventDate;
  final String location;
  final String coordinates;
  final String maxCapacity;
  final String? locationError;
  final String? coordinatesError;
  final String? maxCapacityError;

  const CreateEventState({
    this.eventName = '',
    this.description = '',
    this.eventType = EventType.text_party,
    this.eventNameError,
    this.descriptionError,
    this.eventDate,
    this.eventTime,
    this.eventDateError,
    this.formattedEventDate,
    this.location = '',
    this.coordinates = '',
    this.maxCapacity = '',
    this.locationError,
    this.coordinatesError,
    this.maxCapacityError,
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
    String? formattedEventDate,
    String? location,
    String? coordinates,
    String? maxCapacity,
    String? locationError,
    String? coordinatesError,
    String? maxCapacityError,
    bool clearDate = false,
    bool clearTime = false,
    bool clearDateError = false,
    bool clearLocationError = false,
    bool clearCoordinatesError = false,
    bool clearMaxCapacityError = false,
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
      formattedEventDate: formattedEventDate ?? this.formattedEventDate,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      locationError: clearLocationError ? null : (locationError ?? this.locationError),
      coordinatesError: clearCoordinatesError ? null : (coordinatesError ?? this.coordinatesError),
      maxCapacityError: clearMaxCapacityError ? null : (maxCapacityError ?? this.maxCapacityError),
    );
  }

  @override
  List<Object?> get props => [eventName, description, eventType, eventNameError, descriptionError, eventDate, eventTime, eventDateError, formattedEventDate, location, coordinates, maxCapacity, locationError, coordinatesError, maxCapacityError];
}
