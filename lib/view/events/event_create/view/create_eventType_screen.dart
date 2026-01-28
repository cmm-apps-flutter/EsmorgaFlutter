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
  const CreateEventTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const _CreateEventTypeForm();
  }
}

class _CreateEventTypeForm extends StatefulWidget {
  const _CreateEventTypeForm();

  @override
  State<_CreateEventTypeForm> createState() => _CreateEventTypeFormState();
}

class _CreateEventTypeFormState extends State<_CreateEventTypeForm> {
  late CreateEventCubit _cubit;
  late AppLocalizations _l10n;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateEventCubit>();
    _l10n = getIt<LocalizationService>().current;
    _cubit.effects.listen((effect) {
      if (!mounted) return;
      if (effect is CreateEventEffectNavigateToTypeStep) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Event types list using cached localization strings
    final eventTypes = [
      (EventType.text_party, _l10n.step2OptionParty),
      (EventType.text_sport, _l10n.step2OptionSport),
      (EventType.text_food, _l10n.step2OptionFood),
      (EventType.text_charity, _l10n.step2OptionCharity),
      (EventType.text_games, _l10n.step2OptionGames),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                        for (final eventType in eventTypes)
                          EsmorgaRadiobutton(
                            text: eventType.$2,
                            isSelected: state.eventType == eventType.$1,
                            onTap: () => _cubit.updateEventType(eventType.$1),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    EsmorgaButton(
                      text: _l10n.stepContinueButton,
                      onClick: () {
                        // TODO : Navigate to the third step
                      },
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
