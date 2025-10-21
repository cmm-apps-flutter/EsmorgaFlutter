import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_loader.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';
import 'package:esmorga_flutter/view/events/my_events/cubit/my_events_cubit.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyEventsCubit>(),
      child: const _MyEventsForm(),
    );
  }
}

class _MyEventsForm extends StatefulWidget {
  const _MyEventsForm();

  @override
  State<_MyEventsForm> createState() => _MyEventsFormState();
}

class _MyEventsFormState extends State<_MyEventsForm> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<MyEventsCubit>();
    cubit.load();
    cubit.effects.listen((effect) {
      if (effect is MyEventsEffectShowNoNetworkPrompt) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.snackbarNoInternet)),
        );
      } else if (effect is MyEventsEffectNavigateToEventDetail) {
        final id = effect.event.id;
        context.push('${AppRoutes.eventDetail}/$id');
      } else if (effect is MyEventsEffectNavigateToSignIn) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                        return _MyEventsLoggedOut(
                          onSignIn: () => context.read<MyEventsCubit>().signIn(),
                        );
                      case MyEventsEffectType.emptyList:
                        return _MyEventsEmpty(localizations.screenMyEventsEmptyText);
                      case MyEventsEffectType.unknown:
                        return _MyEventsError(
                          title: localizations.defaultErrorTitle,
                          body: localizations.defaultErrorBody,
                          buttonLabel: localizations.buttonRetry,
                          onRetry: () => context.read<MyEventsCubit>().load(),
                        );
                    }
                  }
                  return _MyEventsList(events: state.eventList);
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
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: EsmorgaText(
              text: localizations.screenEventListLoading,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              'assets/images/event_list_empty.png',
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
                  child: Icon(
                    Icons.event_outlined,
                    size: 64.0,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              },
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

class _MyEventsLoggedOut extends StatelessWidget {
  final VoidCallback onSignIn;

  const _MyEventsLoggedOut({required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.primary,
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
                            text: l.unauthenticatedErrorMessage,
                            style: EsmorgaTextStyle.heading2,
                          ),
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
            text: l.buttonLogin,
            onClick: onSignIn,
          ),
        ],
      ),
    );
  }
}

class _MyEventsList extends StatelessWidget {
  final List<EventListUiModel> events;

  const _MyEventsList({required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: GestureDetector(
            onTap: () {
              context.read<MyEventsCubit>().onEventClick(event.id);
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
                        child: Icon(
                          Icons.event_outlined,
                          size: 64.0,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
