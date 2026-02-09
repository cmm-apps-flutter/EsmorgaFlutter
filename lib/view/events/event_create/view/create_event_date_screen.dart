import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_datepicker.dart';
import 'package:esmorga_flutter/ds/esmorga_row.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_timepicker.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventDateScreen extends StatefulWidget {
  final void Function(String eventName, String description, String eventType, String eventDate) onNavigateToNextStep;
  final VoidCallback onBackClicked;
  final DateTime? mockCurrentDate;

  const CreateEventDateScreen({
    super.key,
    required this.onNavigateToNextStep,
    required this.onBackClicked,
    this.mockCurrentDate,
  });

  @override
  State<CreateEventDateScreen> createState() => _CreateEventDateScreenState();
}

class _CreateEventDateScreenState extends State<CreateEventDateScreen> {
  late CreateEventCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateEventCubit>();
    final now = widget.mockCurrentDate ?? DateTime.now();
    _cubit.updateEventDate(DateTime(now.year, now.month, now.day));
    _cubit.effects.listen((effect) {
      if (!mounted) return;
      if (effect is CreateEventDateConfirmedEffect) {
        widget.onNavigateToNextStep(
          effect.eventData.eventName,
          effect.eventData.description,
          effect.eventData.eventTypeName!,
          effect.eventData.formattedEventDate!,
        );
      }
    });
  }

  Future<void> _showTimePicker() async {
    final localizations = getIt<LocalizationService>().current;
    await EsmorgaTimePickerDialog.show(
      context: context,
      initialTime: _cubit.state.eventTime ?? TimeOfDay.now(),
      confirmButtonText: localizations.confirmButtonDialog,
      dismissButtonText: localizations.cancelButtonDialog,
      selectTimeHelpText: localizations.step3ScreenSelectTimeHelpText,
      onTimeSelected: _cubit.updateEventTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = getIt<LocalizationService>().current;

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
                      text: localizations.step3ScreenTitle,
                      style: EsmorgaTextStyle.body1,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: EsmorgaDatePicker(
                        initialDate: state.eventDate,
                        currentDate: widget.mockCurrentDate,
                        onDateChanged: _cubit.updateEventDate,
                      ),
                    ),
                    Semantics(
                      label: localizations.step3ScreenRowTime,
                      hint: _cubit.formattedEventTime,
                      button: true,
                      child: Focus(
                        child: EsmorgaRow(
                          key: const Key('create_event_time_row'),
                          title: localizations.step3ScreenRowTime,
                          caption: _cubit.formattedEventTime,
                          onClick: _showTimePicker,
                        ),
                      ),
                    ),
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
