import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_loader.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_cubit.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_effect.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_state.dart';
import 'package:esmorga_flutter/view/home_tab/model/home_tab_ui_model.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:esmorga_flutter/view/home_tab/model/poll_ui_model.dart';

class HomeTabScreen extends StatelessWidget {
  final Future<void> Function(Event) onDetailsClicked;
  final Future<void> Function(Poll) onPollClicked;

  const HomeTabScreen({
    super.key,
    required this.onDetailsClicked,
    required this.onPollClicked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<HomeTabCubit>(),
      child: _HomeTabForm(
        onDetailsClicked: onDetailsClicked,
        onPollClicked: onPollClicked,
      ),
    );
  }
}

class _HomeTabForm extends StatefulWidget {
  final Future<void> Function(Event) onDetailsClicked;
  final Future<void> Function(Poll) onPollClicked;

  const _HomeTabForm({
    required this.onDetailsClicked,
    required this.onPollClicked,
  });

  @override
  State<_HomeTabForm> createState() => _HomeTabFormState();
}

class _HomeTabFormState extends State<_HomeTabForm> {
  late final HomeTabCubit _cubit;
  StreamSubscription<HomeTabEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeTabCubit>();
    _cubit.loadEvents();
    _effectSubscription = _cubit.effects.listen((effect) async {
      if (effect is NavigateToEventDetailsEffect) {
        await widget.onDetailsClicked(effect.event);
        _cubit.loadEvents();
      } else if (effect is NavigateToPollDetailsEffect) {
        await widget.onPollClicked(effect.poll);
        _cubit.loadEvents();
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
        child: BlocListener<HomeTabCubit, HomeTabState>(
          listenWhen: (previous, current) =>
              previous.showNoNetworkPrompt == false && current.showNoNetworkPrompt == true,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.snackbarNoInternet)));
            _cubit.clearNoNetworkPrompt();
          },
          child: BlocBuilder<HomeTabCubit, HomeTabState>(
            builder: (context, state) {
              Widget body;
              if (state.loading) {
                body = HomeTabLoadingWidget(title: l10n.screenEventListLoading);
              } else if (state.error != null) {
                body = HomeTabErrorWidget(
                  title: l10n.defaultErrorTitle,
                  message: l10n.defaultErrorBody,
                  retryText: l10n.buttonRetry,
                  onRetry: () => _cubit.loadEvents(),
                );
              } else {
                body = HomeTabWidget(
                  events: state.eventList,
                  polls: state.pollList,
                  onDetailsClicked: _cubit.onEventClicked,
                  onPollClicked: _cubit.onPollClicked,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: EsmorgaText(
                      text: l10n.titleExplore,
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

class HomeTabLoadingWidget extends StatelessWidget {
  final String title;

  const HomeTabLoadingWidget({super.key, required this.title});

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

class HomeTabEmptyWidget extends StatelessWidget {
  final String text;

  const HomeTabEmptyWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset('assets/images/event_list_empty.jpg',
                width: double.infinity, height: 200.0, fit: BoxFit.cover),
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

class HomeTabErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final String retryText;
  final VoidCallback onRetry;

  const HomeTabErrorWidget({
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

class HomeTabWidget extends StatelessWidget {
  final List<HomeTabUiModel> events;
  final List<PollUiModel> polls;
  final ValueChanged<String> onDetailsClicked;
  final ValueChanged<String> onPollClicked;

  const HomeTabWidget({
    super.key,
    required this.events,
    required this.polls,
    required this.onDetailsClicked,
    required this.onPollClicked,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        if (polls.isNotEmpty) ...[
          _SectionHeader(title: l10n.titlePolls),
          ...polls.map((poll) => Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: HomeTabCard(
                  imageUrl: poll.imageUrl,
                  title: poll.title,
                  subtitle1: poll.deadline,
                  onTap: () => onPollClicked(poll.id),
                ),
              )),
        ],
        _SectionHeader(title: l10n.titleEvents),
        if (events.isEmpty)
          HomeTabEmptyWidget(text: l10n.textEmptyState)
        else
          ...events.map((event) => Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: HomeTabCard(
                  imageUrl: event.imageUrl,
                  title: event.cardTitle,
                  subtitle1: event.cardSubtitle1,
                  subtitle2: event.cardSubtitle2,
                  onTap: () => onDetailsClicked(event.id),
                ),
              )),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: EsmorgaText(
            text: title,
            style: EsmorgaTextStyle.heading2,
          ),
        ),
        Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class HomeTabCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String subtitle1;
  final String? subtitle2;
  final VoidCallback onTap;

  const HomeTabCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle1,
    this.subtitle2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              imageUrl ?? '',
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
              text: title,
              style: EsmorgaTextStyle.heading2,
              key: const Key('event_list_event_name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: EsmorgaText(
              text: subtitle1,
              style: EsmorgaTextStyle.body1Accent,
            ),
          ),
          if (subtitle2 != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: EsmorgaText(
                text: subtitle2!,
                style: EsmorgaTextStyle.body1Accent,
              ),
            ),
        ],
      ),
    );
  }
}
