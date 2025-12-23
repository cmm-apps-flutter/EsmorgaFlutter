import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_loader.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/events/my_events/cubit/my_events_cubit.dart';
import 'package:esmorga_flutter/view/home/logged_out_view.dart';
import 'package:esmorga_flutter/view/home_tab/model/home_tab_ui_model.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class MyEventsScreen extends StatelessWidget {
  final Future<bool?> Function(Event) onDetailsClicked;
  final void Function() onSignInClicked;

  const MyEventsScreen({super.key, required this.onDetailsClicked, required this.onSignInClicked});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyEventsCubit>(),
      child: _MyEventsForm(onDetailsClicked, onSignInClicked),
    );
  }
}

class _MyEventsForm extends StatefulWidget {
  final Future<bool?> Function(Event) onDetailsClicked;
  final void Function() onSignInClicked;

  const _MyEventsForm(this.onDetailsClicked, this.onSignInClicked);

  @override
  State<_MyEventsForm> createState() => _MyEventsFormState();
}

class _MyEventsFormState extends State<_MyEventsForm> {
  late MyEventsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MyEventsCubit>();
    _cubit.load();
    _cubit.effects.listen((effect) async {
      if (effect is MyEventsEffectShowNoNetworkPrompt) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getIt<LocalizationService>().current.snackbarNoInternet)),
        );
      } else if (effect is MyEventsEffectNavigateToEventDetail) {
        final didChange = await widget.onDetailsClicked(effect.event);
        if (didChange == true) {
          _cubit.load(forceRefresh: true);
        }
      } else if (effect is MyEventsEffectNavigateToSignIn) {
        widget.onSignInClicked();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = getIt<LocalizationService>().current;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: EsmorgaText(
                text: localizations.screenMyEventsTitle,
                style: EsmorgaTextStyle.heading1,
                key: const Key('my_event_list_screen_title'),
              ),
            ),
            Expanded(
              child: BlocBuilder<MyEventsCubit, MyEventsState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const _MyEventsLoading();
                  }
                  if (state.error != null) {
                    switch (state.error!) {
                      case MyEventsEffectType.notLoggedIn:
                        return LoggedOutView(
                          onSignIn: () => _cubit.signIn(),
                        );
                      case MyEventsEffectType.emptyList:
                        return _MyEventsEmpty(localizations.screenMyEventsEmptyText);
                      case MyEventsEffectType.unknown:
                        return _MyEventsError(
                          title: localizations.defaultErrorTitle,
                          body: localizations.defaultErrorBody,
                          buttonLabel: localizations.buttonRetry,
                          onRetry: () => _cubit.load(),
                        );
                    }
                  }
                  return _MyEventsList(
                      events: state.eventList,
                      onEventClick: (eventId) {
                        _cubit.onEventClick(eventId);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyEventsLoading extends StatelessWidget {
  const _MyEventsLoading();

  @override
  Widget build(BuildContext context) {
    final localizations = getIt<LocalizationService>().current;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: EsmorgaText(
              text: localizations.body_loader,
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

class _MyEventsEmpty extends StatelessWidget {
  final String text;

  const _MyEventsEmpty(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: EsmorgaText(
              text: text,
              style: EsmorgaTextStyle.heading1,
            )),
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Lottie.asset(
              'assets/animations/empty.json',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _MyEventsError extends StatelessWidget {
  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onRetry;

  const _MyEventsError({
    required this.title,
    required this.body,
    required this.buttonLabel,
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
                          text: body,
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
            text: buttonLabel,
            onClick: onRetry,
          ),
        ],
      ),
    );
  }
}

class _MyEventsList extends StatelessWidget {
  final List<HomeTabUiModel> events;
  final Function(String) onEventClick;

  const _MyEventsList({required this.events, required this.onEventClick});

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
              onEventClick(event.id);
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
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: EsmorgaText(
                    text: event.cardTitle,
                    style: EsmorgaTextStyle.heading2,
                    key: const Key('my_event_list_event_name'),
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
