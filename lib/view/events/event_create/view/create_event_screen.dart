import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventScreen extends StatelessWidget {
  
  final void Function(String eventName, String description) onNavigateToNextStep;

  
  final VoidCallback onBackClicked;

  const CreateEventScreen({
    super.key,
    required this.onNavigateToNextStep,
    required this.onBackClicked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateEventCubit>(),
      child: _CreateEventForm(
        onNavigateToNextStep: onNavigateToNextStep,
        onBackClicked: onBackClicked,
      ),
    );
  }
}


class _CreateEventForm extends StatefulWidget {

  final void Function(String eventName, String description) onNavigateToNextStep;


  final VoidCallback onBackClicked;

  const _CreateEventForm({
    required this.onNavigateToNextStep,
    required this.onBackClicked,
  });

  @override
  State<_CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<_CreateEventForm> {
  late CreateEventCubit _cubit;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateEventCubit>();
    _cubit.effects.listen((effect) {
      if (!mounted) return;
      if (effect is CreateEventEffectNavigateToNextStep) {
        widget.onNavigateToNextStep(
          effect.eventName,
          effect.description,
        );
      }
    });
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = getIt<LocalizationService>().current;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                    const SizedBox(height: 32.0),
                    EsmorgaTextField(
                      key: const Key('create_event_name_input'),
                      controller: _nameController,
                      title: localizations.fieldTitleEventName,
                      placeholder: localizations.placeholderEventName,
                      errorText: state.eventNameError,
                      onChanged: _cubit.updateEventName,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EsmorgaTextField(
                          key: const Key('create_event_description_input'),
                          controller: _descriptionController,
                          maxLines: 5,
                          maxChars: 5000,
                          onChanged: _cubit.updateDescription,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(5000),
                          ],
                          title: localizations.fieldTitleEventDescription,
                          placeholder: localizations.placeholderEventDescription,
                          errorText: state.descriptionError,
                        ),
                      ],
                    ),
                    const SizedBox(height: 48.0),
                    EsmorgaButton(
                      text: localizations.stepContinueButton,
                      isEnabled: _cubit.canProceedFromScreen1(),
                      onClick: _cubit.submit,
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
