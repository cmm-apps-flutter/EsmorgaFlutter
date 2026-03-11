import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_datepicker.dart';
import 'package:esmorga_flutter/ds/esmorga_row.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_timepicker.dart';
import 'package:esmorga_flutter/ds/esmorga_toggle.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventDateScreen extends StatefulWidget {
  final void Function(EventCreationData eventData) onNavigateToNextStep;
  final VoidCallback onBackClicked;

  const CreateEventDateScreen({
    super.key,
    required this.onNavigateToNextStep,
    required this.onBackClicked,
  });

  @override
  State<CreateEventDateScreen> createState() => _CreateEventDateScreenState();
}

class _CreateEventDateScreenState extends State<CreateEventDateScreen> {
  late CreateEventCubit _cubit;
  late final LocalizationService _l10nService;
  StreamSubscription<CreateEventEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateEventCubit>();
    _l10nService = getIt<LocalizationService>();
    _cubit.initializeEventDate();
    _effectSubscription = _cubit.effects.listen((effect) {
      if (!mounted) return;
      if (effect is CreateEventDateConfirmedEffect) {
        widget.onNavigateToNextStep(effect.eventData);
      }
    });
  }

  @override
  void dispose() {
    _effectSubscription?.cancel();
    super.dispose();
  }

  Future<void> _showTimePicker() async {
    final localizations = _l10nService.current;
    await EsmorgaTimePickerDialog.show(
      context: context,
      initialTime: _cubit.state.eventTime ?? TimeOfDay.now(),
      confirmButtonText: localizations.confirmButtonDialog,
      dismissButtonText: localizations.cancelButtonDialog,
      selectTimeHelpText: localizations.createEventDateSelectTimeHelpText,
      onTimeSelected: _cubit.updateEventTime,
    );
  }

  Future<void> _showJoinDeadlineTimePicker() async {
    final localizations = _l10nService.current;
    await EsmorgaTimePickerDialog.show(
      context: context,
      initialTime: _cubit.state.joinDeadlineTime ?? const TimeOfDay(hour: 23, minute: 59),
      confirmButtonText: localizations.confirmButtonDialog,
      dismissButtonText: localizations.cancelButtonDialog,
      selectTimeHelpText: localizations.selectJoinDeadlineTimeHelpText,
      onTimeSelected: _cubit.updateJoinDeadlineTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = _l10nService.current;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: localizations.tooltipBackIcon,
          onPressed: widget.onBackClicked,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<CreateEventCubit, CreateEventState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32.0),
                    EsmorgaText(
                      text: localizations.screenCreateEventTitle,
                      style: EsmorgaTextStyle.heading1,
                    ),
                    const SizedBox(height: 16.0),
                    EsmorgaText(
                      text: localizations.createEventDateScreenTitle,
                      style: EsmorgaTextStyle.body1,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: EsmorgaDatePicker(
                        initialDate: state.eventDate,
                        currentDate: _cubit.currentDate,
                        onDateChanged: _cubit.updateEventDate,
                      ),
                    ),
                    Semantics(
                      label: localizations.createEventDateRowTime,
                      hint: _cubit.formattedEventTime,
                      button: true,
                      child: Focus(
                        child: EsmorgaRow(
                          key: const Key('create_event_time_row'),
                          title: localizations.createEventDateRowTime,
                          caption: _cubit.formattedEventTime,
                          onClick: _showTimePicker,
                        ),
                      ),
                    ),
                    if (state.eventDateError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: EsmorgaText(
                          key: const Key('create_event_date_error'),
                          text: state.eventDateError!,
                          style: EsmorgaTextStyle.captionError,
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    EsmorgaToggle(
                      key: const Key('create_event_join_deadline_toggle'),
                      text: localizations.fieldTitleJoinDeadline,
                      isEnabled: state.joinDeadlineEnabled,
                      onChanged: _cubit.toggleJoinDeadline,
                    ),
                    if (state.joinDeadlineEnabled) ...[
                      SizedBox(
                        width: double.infinity,
                        child: EsmorgaDatePicker(
                          key: const Key('create_event_join_deadline_datepicker'),
                          initialDate: state.joinDeadlineDate,
                          currentDate: _cubit.currentDate,
                          onDateChanged: _cubit.updateJoinDeadlineDate,
                        ),
                      ),
                      Semantics(
                        label: localizations.fieldTitleJoinDeadlineTime,
                        hint: _cubit.formattedJoinDeadlineTime,
                        button: true,
                        child: Focus(
                          child: EsmorgaRow(
                            key: const Key('create_event_join_deadline_time_row'),
                            title: localizations.fieldTitleJoinDeadlineTime,
                            caption: _cubit.formattedJoinDeadlineTime,
                            onClick: _showJoinDeadlineTimePicker,
                          ),
                        ),
                      ),
                      if (state.joinDeadlineError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: EsmorgaText(
                            key: const Key('create_event_join_deadline_error'),
                            text: state.joinDeadlineError!,
                            style: EsmorgaTextStyle.captionError,
                          ),
                        ),
                    ],
                    const SizedBox(height: 32.0),
                    EsmorgaButton(
                      key: const Key('create_event_date_continue_button'),
                      text: localizations.stepContinueButton,
                      isEnabled: _cubit.canProceedFromScreen3(),
                      onClick: _cubit.submitDateStep,
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
