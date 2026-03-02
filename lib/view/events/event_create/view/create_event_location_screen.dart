import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventLocationScreen extends StatefulWidget {
  final void Function(EventCreationData eventData) onNavigateToNextStep;
  final VoidCallback onBackClicked;

  const CreateEventLocationScreen({
    super.key,
    required this.onNavigateToNextStep,
    required this.onBackClicked,
  });

  @override
  State<CreateEventLocationScreen> createState() => _CreateEventLocationScreenState();
}

class _CreateEventLocationScreenState extends State<CreateEventLocationScreen> {
  late CreateEventCubit _cubit;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _coordinatesController = TextEditingController();
  final TextEditingController _maxCapacityController = TextEditingController();
  StreamSubscription<CreateEventEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateEventCubit>();
    _effectSubscription = _cubit.effects.listen((effect) {
      if (!mounted) return;
      if (effect is CreateEventLocationConfirmedEffect) {
        widget.onNavigateToNextStep(effect.eventData);
      }
    });
  }

  @override
  void dispose() {
    _effectSubscription?.cancel();
    _locationController.dispose();
    _coordinatesController.dispose();
    _maxCapacityController.dispose();
    super.dispose();
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
                    EsmorgaTextField(
                      key: const Key('create_event_location_input'),
                      controller: _locationController,
                      title: localizations.fieldTitleEventLocation,
                      placeholder: localizations.placeholderEventLocation,
                      errorText: state.locationError,
                      errorMaxLines: 3,
                      onChanged: _cubit.updateLocation,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(maximumLocationLength),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    EsmorgaTextField(
                      key: const Key('create_event_coordinates_input'),
                      controller: _coordinatesController,
                      title: localizations.fieldTitleEventCoordinates,
                      placeholder: localizations.placeholderEventCoordinates,
                      errorText: state.coordinatesError,
                      onChanged: _cubit.updateCoordinates,
                    ),
                    const SizedBox(height: 32.0),
                    EsmorgaTextField(
                      key: const Key('create_event_max_capacity_input'),
                      controller: _maxCapacityController,
                      title: localizations.fieldTitleEventMaxCapacity,
                      placeholder: localizations.placeholderEventMaxCapacity,
                      errorText: state.maxCapacityError,
                      onChanged: _cubit.updateMaxCapacity,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final stripped = newValue.text.replaceFirst(RegExp(r'^0+(?=\d)'), '');
                          return stripped == newValue.text
                              ? newValue
                              : newValue.copyWith(
                                  text: stripped,
                                  selection: TextSelection.collapsed(offset: stripped.length),
                                );
                        }),
                      ],
                    ),
                    const SizedBox(height: 48.0),
                    EsmorgaButton(
                      key: const Key('create_event_location_continue_button'),
                      text: localizations.stepContinueButton,
                      isEnabled: _cubit.canProceedFromScreen4(),
                      onClick: _cubit.submitLocationStep,
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
