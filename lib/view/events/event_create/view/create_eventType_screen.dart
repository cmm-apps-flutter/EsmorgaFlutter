import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_radiobutton.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/events/event_create/model/event_type.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateEventTypeScreen extends StatelessWidget {
  final void Function(String eventName, String description, EventType eventType) onNavigateToNextStep;

  const CreateEventTypeScreen({
    super.key,
    required this.onNavigateToNextStep,
  });

  @override
  Widget build(BuildContext context) {
    return _CreateEventTypeForm(onNavigateToNextStep: onNavigateToNextStep);
  }
}

class _CreateEventTypeForm extends StatefulWidget {
  final void Function(String eventName, String description, EventType eventType) onNavigateToNextStep;

  const _CreateEventTypeForm({required this.onNavigateToNextStep});

  @override
  State<_CreateEventTypeForm> createState() => _CreateEventTypeFormState();
}

class _CreateEventTypeFormState extends State<_CreateEventTypeForm> {
  late CreateEventCubit _cubit;
  late AppLocalizations _l10n;
  StreamSubscription<CreateEventEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateEventCubit>();
    _l10n = getIt<LocalizationService>().current;
    _effectSubscription = _cubit.effects.listen((effect) {
      if (!mounted) return;
      if (effect is CreateEventNavigateToEventTypeEffect) {
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    _effectSubscription?.cancel();
    super.dispose();
  }

  void _onContinuePressed() {
    final state = _cubit.state;
    if (state.eventType != null) {
      widget.onNavigateToNextStep(
        state.eventName,
        state.description,
        state.eventType!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: _l10n.tooltipBackIcon,
          onPressed: () => context.pop(),
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
                      text: _l10n.screenCreateEventTitle,
                      style: EsmorgaTextStyle.heading1,
                    ),
                    const SizedBox(height: 16.0),
                    EsmorgaText(
                      text: _l10n.step2ScreenTitle,
                      style: EsmorgaTextStyle.body1,
                    ),
                    const SizedBox(height: 32.0),
                    Column(
                      children: [
                        for (final eventType in EventType.values)
                          EsmorgaRadiobutton(
                            text: eventType.localizedName(_l10n),
                            isSelected: state.eventType == eventType,
                            onTap: () => _cubit.updateEventType(eventType),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    EsmorgaButton(
                      text: _l10n.stepContinueButton,
                      onClick: _onContinuePressed,
                      isEnabled: state.eventType != null,
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
