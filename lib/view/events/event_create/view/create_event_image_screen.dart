import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventImageScreen extends StatefulWidget {
  final VoidCallback onSubmitSuccess;
  final VoidCallback onBackClicked;

  const CreateEventImageScreen({
    super.key,
    required this.onSubmitSuccess,
    required this.onBackClicked,
  });

  @override
  State<CreateEventImageScreen> createState() => _CreateEventImageScreenState();
}

class _CreateEventImageScreenState extends State<CreateEventImageScreen> {
  static const double _bottomButtonBottomPadding = 32.0;

  late CreateEventCubit _cubit;
  final TextEditingController _imageUrlController = TextEditingController();
  StreamSubscription<CreateEventEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CreateEventCubit>();
    _effectSubscription = _cubit.effects.listen((effect) {
      if (!mounted) return;
      if (effect is CreateEventImageConfirmedEffect) {
        widget.onSubmitSuccess();
      }
    });
  }

  @override
  void dispose() {
    _effectSubscription?.cancel();
    _imageUrlController.dispose();
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
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.0,
            8.0,
            16.0,
            MediaQuery.of(context).viewInsets.bottom + _bottomButtonBottomPadding,
          ),
          child: EsmorgaButton(
            key: const Key('button_create_event'),
            text: localizations.buttonCreateEvent,
            onClick: _cubit.submitImageStep,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocConsumer<CreateEventCubit, CreateEventState>(
            listenWhen: (previous, current) =>
                previous.eventImageUrl.isNotEmpty && current.eventImageUrl.isEmpty,
            listener: (context, state) {
              _imageUrlController.clear();
            },
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
                      key: const Key('create_event_image_url_input'),
                      controller: _imageUrlController,
                      title: localizations.fieldTitleEventImage,
                      placeholder: localizations.placeholderEventImage,
                      errorText: state.eventImageUrlError,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16.0),
                    if (state.eventImageUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            key: const Key('create_event_image_preview'),
                            state.eventImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, __) => ColoredBox(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      EsmorgaButton(
                        key: const Key('button_delete'),
                        text: localizations.buttonDelete,
                        onClick: _cubit.clearEventImageUrl,
                        primary: false,
                      ),
                    ] else ...[
                      EsmorgaButton(
                        key: const Key('button_preview'),
                        text: localizations.buttonPreview,
                        onClick: () => _cubit.validateAndPreviewImageUrl(
                          _imageUrlController.text,
                        ),
                        primary: false,
                      ),
                    ],
                    const SizedBox(height: 16.0),
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
