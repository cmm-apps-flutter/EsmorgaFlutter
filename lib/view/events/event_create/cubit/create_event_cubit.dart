import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esmorga_flutter/view/events/event_create/model/event_type.dart';

part 'create_event_state.dart';

sealed class CreateEventEffect {}

const minimumDescriptionLength = 20;
const maximumDescriptionLength = 5000;
const maximumEventNameLength = 100;
const minimumEventNameLength = 3;

class EventCreationData {
  final String eventName;
  final String description;
  final String? eventTypeName;
  final String? formattedEventDate;

  const EventCreationData({
    required this.eventName,
    required this.description,
    this.eventTypeName,
    this.formattedEventDate,
  });

  EventCreationData copyWith({
    String? eventName,
    String? description,
    String? eventTypeName,
    String? formattedEventDate,
  }) {
    return EventCreationData(
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      eventTypeName: eventTypeName ?? this.eventTypeName,
      formattedEventDate: formattedEventDate ?? this.formattedEventDate,
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

class CreateEventCubit extends Cubit<CreateEventState> {
  final AppLocalizations l10n;
  final EsmorgaDateTimeFormatter dateTimeFormatter;

  final _effectController = StreamController<CreateEventEffect>.broadcast();
  Stream<CreateEventEffect> get effects => _effectController.stream;

  CreateEventCubit({
    required this.l10n,
    required this.dateTimeFormatter,
  }) : super(const CreateEventState());

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
    final today = DateTime.now();
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

  bool get isFormValid =>
      state.eventName.isNotEmpty &&
      state.eventNameError == null &&
      state.description.isNotEmpty &&
      state.descriptionError == null &&
      state.eventType != null;

  void submit() {
    _effectController.add(CreateEventNavigateToEventTypeEffect(
      eventData: EventCreationData(
        eventName: state.eventName,
        description: state.description,
      ),
    ));
  }

  void submitDateStep() {
    final formattedDate = getFormattedEventDate();
    if (formattedDate == null) return;
    _effectController.add(CreateEventDateConfirmedEffect(
      eventData: EventCreationData(
        eventName: state.eventName,
        description: state.description,
        eventTypeName: state.eventType!.name,
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
