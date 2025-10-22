import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_loader.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_list_cubit.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_list_effect.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventListScreen extends StatelessWidget {
  final void Function(Event) onDetailsClicked;

  const EventListScreen({super.key, required this.onDetailsClicked});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<EventListCubit>(),
      child: _EventListForm(
        onDetailsClicked: onDetailsClicked,
      ),
    );
  }
}

class _EventListForm extends StatefulWidget {
  final ValueChanged<Event> onDetailsClicked;

  const _EventListForm({required this.onDetailsClicked});

  @override
  State<_EventListForm> createState() => _EventListFormState();
}

class _EventListFormState extends State<_EventListForm> {
  late final EventListCubit _cubit;
  StreamSubscription<EventListEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<EventListCubit>();
    _cubit.loadEvents();
    _effectSubscription = _cubit.effects.listen((effect) {
      if (effect is NavigateToEventDetailsEffect) {
        widget.onDetailsClicked(effect.event);
      }
    });
  }

  @override
  void dispose() {
    _effectSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<EventListCubit, EventListState>(
          listenWhen: (previous, current) => previous.showNoNetworkPrompt == false && current.showNoNetworkPrompt == true,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.snackbarNoInternet)));
            _cubit.clearNoNetworkPrompt();
          },
          child: BlocBuilder<EventListCubit, EventListState>(
            builder: (context, state) {
              Widget body;
              if (state.loading) {
                body = EventListLoadingWidget(title: l10n.screenEventListLoading);
              } else if (state.eventList.isEmpty && state.error == null) {
                body = EventListEmptyWidget(text: l10n.screenEventListEmptyText);
              } else if (state.error != null) {
                body = EventListErrorWidget(
                  title: l10n.defaultErrorTitle,
                  message: l10n.defaultErrorBody,
                  retryText: l10n.buttonRetry,
                  onRetry: () => _cubit.loadEvents(),
                );
              } else {
                body = EventListWidget(events: state.eventList, onDetailsClicked: _cubit.onEventClicked);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: EsmorgaText(
                      text: l10n.screenEventListTitle,
                      style: EsmorgaTextStyle.heading1,
                      key: const Key('event_list_screen_title'),
                    ),
                  ),
                  Expanded(child: body),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class EventListLoadingWidget extends StatelessWidget {
  final String title;

  const EventListLoadingWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: EsmorgaText(
              text: title,
              style: EsmorgaTextStyle.heading1,
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: EsmorgaLinearLoader(),
          ),
        ],
      ),
    );
  }
}

class EventListEmptyWidget extends StatelessWidget {
  final String text;

  const EventListEmptyWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              'assets/images/event_list_empty.jpg',
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: EsmorgaText(
              text: text,
              style: EsmorgaTextStyle.heading2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class EventListErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final String retryText;
  final VoidCallback onRetry;

  const EventListErrorWidget({
    super.key,
    required this.title,
    required this.message,
    required this.retryText,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: EsmorgaText(
                            text: title,
                            style: EsmorgaTextStyle.heading2,
                          ),
                        ),
                        EsmorgaText(
                          text: message,
                          style: EsmorgaTextStyle.body1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          EsmorgaButton(
            text: retryText,
            onClick: onRetry,
          ),
        ],
      ),
    );
  }
}

class EventListWidget extends StatelessWidget {
  final List<EventListUiModel> events;
  final ValueChanged<String> onDetailsClicked;

  const EventListWidget({super.key, required this.events, required this.onDetailsClicked});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: InkWell(
            onTap: () {
              final id = event.id;
              onDetailsClicked(id);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    event.imageUrl ?? '',
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Image.asset(
                          'assets/images/event_list_empty.jpg',
                          width: double.infinity,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: EsmorgaText(
                    text: event.cardTitle,
                    style: EsmorgaTextStyle.heading2,
                    key: const Key('event_list_event_name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: EsmorgaText(
                    text: event.cardSubtitle1,
                    style: EsmorgaTextStyle.body1Accent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: EsmorgaText(
                    text: event.cardSubtitle2,
                    style: EsmorgaTextStyle.body1Accent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
