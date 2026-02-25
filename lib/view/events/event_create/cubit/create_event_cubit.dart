import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/util/esmorga_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esmorga_flutter/view/events/event_create/model/event_type.dart';

part 'create_event_state.dart';

sealed class CreateEventEffect {}

const minimumDescriptionLength = 20;
const maximumDescriptionLength = 5000;
const maximumEventNameLength = 100;
const minimumEventNameLength = 3;
const maximumLocationLength = 100;
const minimumMaxCapacity = 1;
const maximumMaxCapacity = 5000;

class EventCreationData {
  final String eventName;
  final String description;
  final EventType? eventType;
  final String? formattedEventDate;
  final String? location;
  final String? coordinates;
  final int? maxCapacity;

  const EventCreationData({
    required this.eventName,
    required this.description,
    this.eventType,
    this.formattedEventDate,
    this.location,
    this.coordinates,
    this.maxCapacity,
  });

  factory EventCreationData.fromState(
    CreateEventState state, {
    String? formattedEventDate,
  }) {
    final parsedMaxCapacity = int.tryParse(state.maxCapacity);
    return EventCreationData(
      eventName: state.eventName,
      description: state.description,
      eventType: state.eventType,
      formattedEventDate: formattedEventDate ?? state.formattedEventDate,
      location: state.location.isEmpty ? null : state.location,
      coordinates: state.coordinates.isEmpty ? null : state.coordinates,
      maxCapacity: parsedMaxCapacity,
    );
  }
}

class CreateEventNavigateToEventTypeEffect extends CreateEventEffect {
  final EventCreationData eventData;

  CreateEventNavigateToEventTypeEffect({
    required this.eventData,
  });
}

class CreateEventDateConfirmedEffect extends CreateEventEffect {
  final EventCreationData eventData;

  CreateEventDateConfirmedEffect({
    required this.eventData,
  });
}

class CreateEventLocationConfirmedEffect extends CreateEventEffect {
  final EventCreationData eventData;

  CreateEventLocationConfirmedEffect({
    required this.eventData,
  });
}

class CreateEventCubit extends Cubit<CreateEventState> {
  final AppLocalizations l10n;
  final EsmorgaDateTimeFormatter dateTimeFormatter;
  final EsmorgaClock clock;

  final _effectController = StreamController<CreateEventEffect>.broadcast();
  Stream<CreateEventEffect> get effects => _effectController.stream;

  CreateEventCubit({
    required this.l10n,
    required this.dateTimeFormatter,
    required this.clock,
  }) : super(const CreateEventState());

  void initFromEventData(EventCreationData eventData) {
    emit(state.copyWith(
      eventName: eventData.eventName,
      description: eventData.description,
      eventType: eventData.eventType,
      formattedEventDate: eventData.formattedEventDate,
    ));
  }

  DateTime get currentDate => clock.now();

  void initializeEventDate() {
    final today = currentDate;
    updateEventDate(DateTime(today.year, today.month, today.day));
  }

  void updateEventName(String name) {
    String? error;
    if (name.isEmpty) {
      error = l10n.inlineErrorEmptyField;
    } else if (name.length < minimumEventNameLength || name.length > maximumEventNameLength) {
      error = l10n.inlineErrorInvalidLengthName;
    }

    emit(state.copyWith(
      eventName: name,
      eventNameError: error,
    ));
  }

  void updateDescription(String desc) {
    String? error;
    if (desc.isEmpty) {
      error = l10n.inlineErrorEmptyField;
    } else if (desc.length < minimumDescriptionLength || desc.length > maximumDescriptionLength) {
      error = l10n.inlineErrorInvalidLengthDescription;
    }

    emit(state.copyWith(
      description: desc,
      descriptionError: error,
    ));
  }

  void updateEventType(EventType type) {
    emit(state.copyWith(eventType: type));
  }

  void updateEventDate(DateTime date) {
    final today = clock.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    if (date.isBefore(startOfToday)) {
      emit(state.copyWith(
        eventDate: date,
        eventDateError: l10n.inlineErrorEmptyField,
      ));
      return;
    }
    emit(state.copyWith(
      eventDate: date,
      clearDateError: true,
    ));
  }

  void updateEventTime(TimeOfDay time) {
    emit(state.copyWith(eventTime: time));
  }

  void clearDateAndTime() {
    emit(state.copyWith(clearDate: true, clearTime: true));
  }

  String? get formattedEventTime {
    if (state.eventTime == null) return null;
    final time = state.eventTime!;
    final hourString = time.hour.toString().padLeft(2, '0');
    final minuteString = time.minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }

  String? getFormattedEventDate() {
    if (state.eventDate == null || state.eventTime == null) return null;
    final time = dateTimeFormatter.formatTimeWithMillisUtcSuffix(
      state.eventTime!.hour,
      state.eventTime!.minute,
    );
    return dateTimeFormatter.formatIsoDateTime(state.eventDate!, time);
  }

  bool canProceedFromScreen1() {
    return state.eventName.isNotEmpty &&
        state.eventNameError == null &&
        state.description.isNotEmpty &&
        state.descriptionError == null;
  }

  bool canProceedFromScreen2() {
    return state.eventType != null;
  }

  bool canProceedFromScreen3() {
    return state.eventDate != null &&
        state.eventTime != null &&
        state.eventDateError == null;
  }

  bool canProceedFromScreen4() {
    return state.location.isNotEmpty &&
        state.locationError == null &&
        state.coordinatesError == null &&
        state.maxCapacityError == null;
  }

  bool get isFormValid =>
      state.eventName.isNotEmpty &&
      state.eventNameError == null &&
      state.description.isNotEmpty &&
      state.descriptionError == null &&
      state.eventType != null &&
      state.eventDate != null &&
      state.eventTime != null &&
      state.eventDateError == null &&
      state.location.isNotEmpty &&
      state.locationError == null &&
      state.coordinatesError == null &&
      state.maxCapacityError == null;

  void submit() {
    _effectController.add(CreateEventNavigateToEventTypeEffect(
      eventData: EventCreationData.fromState(state),
    ));
  }

  void submitDateStep() {
    final formattedDate = getFormattedEventDate();
    if (formattedDate == null) return;
    emit(state.copyWith(formattedEventDate: formattedDate));
    _effectController.add(CreateEventDateConfirmedEffect(
      eventData: EventCreationData.fromState(
        state,
        formattedEventDate: formattedDate,
      ),
    ));
  }

  static final _coordinatesRegExp = RegExp(r'^\s*-?\d+\.?\d*\s*,\s*-?\d+\.?\d*\s*$');
  static final _locationCharsRegExp = RegExp(r"^[\p{L}\p{N}\s.,\-'\/#ºª°]+$", unicode: true);

  void updateLocation(String value) {
    String? error;
    if (value.isEmpty) {
      error = l10n.inlineErrorLocationRequired;
    } else if (!_locationCharsRegExp.hasMatch(value)) {
      error = l10n.inlineErrorLocationInvalidChars;
    }
    emit(state.copyWith(
      location: value,
      locationError: error,
      clearLocationError: error == null,
    ));
  }

  void updateCoordinates(String value) {
    String? error;
    if (value.isNotEmpty) {
      if (!_coordinatesRegExp.hasMatch(value)) {
        error = l10n.inlineErrorCoordinatesInvalid;
      } else {
        final parts = value.split(',');
        final latitude = double.tryParse(parts[0].trim());
        final longitude = double.tryParse(parts[1].trim());
        if (latitude == null || longitude == null ||
            latitude < -90 || latitude > 90 ||
            longitude < -180 || longitude > 180) {
          error = l10n.inlineErrorCoordinatesOutOfBounds;
        }
      }
    }
    emit(state.copyWith(
      coordinates: value,
      coordinatesError: error,
      clearCoordinatesError: error == null,
    ));
  }

  void updateMaxCapacity(String value) {
    String? error;
    if (value.isNotEmpty) {
      final parsed = int.tryParse(value);
      if (parsed == null || parsed < minimumMaxCapacity || parsed > maximumMaxCapacity) {
        error = l10n.inlineErrorMaxCapacityInvalid;
      }
    }
    emit(state.copyWith(
      maxCapacity: value,
      maxCapacityError: error,
      clearMaxCapacityError: error == null,
    ));
  }

  void updateFormattedEventDate(String date) {
    emit(state.copyWith(formattedEventDate: date));
  }

  void submitLocationStep() {
    final formattedDate = state.formattedEventDate ?? getFormattedEventDate();
    if (formattedDate == null) return;
    _effectController.add(CreateEventLocationConfirmedEffect(
      eventData: EventCreationData.fromState(
        state,
        formattedEventDate: formattedDate,
      ),
    ));
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
