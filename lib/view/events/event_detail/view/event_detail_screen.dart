import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_effect.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final Function() goToLogin;
  const EventDetailScreen({Key? key, required this.goToLogin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _EventDetailForm(goToLogin: goToLogin);
  }
}

class _EventDetailForm extends StatefulWidget {
  final Function() goToLogin;
  const _EventDetailForm({Key? key, required this.goToLogin}) : super(key: key);

  @override
  State<_EventDetailForm> createState() => _EventDetailFormState();
}

class _EventDetailFormState extends State<_EventDetailForm> {
  late final EventDetailCubit _cubit;

  StreamSubscription<EventDetailEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<EventDetailCubit>();
    _cubit.start();
    _effectSubscription = _cubit.effects.listen((effect) {
      if (!mounted) return;
      final l10n = getIt<LocalizationService>().current;
      if (effect is NavigateBackEffect) {
        context.pop();
      } else if (effect is NavigateToLoginEffect) {
        debugPrint("Navigate");
        widget.goToLogin();
      } else if (effect is ShowJoinSuccessEffect) {
        _showSnack(l10n.snackbarEventJoined);
      } else if (effect is ShowLeaveSuccessEffect) {
        _showSnack(l10n.snackbarEventLeft);
      } else if (effect is ShowNoNetworkEffect) {
        _showSnack(l10n.snackbarNoInternet);
      } else if (effect is ShowGenericErrorEffect) {
        _showSnack(l10n.defaultErrorTitle);
      } else if (effect is OpenMapsEffect) {
        _openMaps(effect.lat, effect.lng, effect.name);
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

    return BlocBuilder<EventDetailCubit, EventDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _cubit.backPressed(),
            ),
          ),
          body: _buildBody(context, state, l10n),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, EventDetailState state, AppLocalizations l10n) {
    String safeDecode(String raw) {
      if (!raw.contains('%')) return raw;
      final hasValidPattern = RegExp(r'%[0-9A-Fa-f]{2}').hasMatch(raw);
      if (!hasValidPattern) return raw;
      try {
        return Uri.decodeComponent(raw);
      } catch (_) {
        return raw;
      }
    }

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.defaultErrorTitle),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _cubit.start(),
              child: Text(l10n.buttonRetry),
            )
          ],
        ),
      );
    }
    
    final ui = state.uiModel;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              ui.imageUrl ?? '',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 200,
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Image.asset(
                  'assets/images/event_list_empty.jpg',
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          EsmorgaText(
            text: ui.title,
            style: EsmorgaTextStyle.heading1,
            key: const Key('event_detail_title'),
          ),
          const SizedBox(height: 8),
          EsmorgaText(text: ui.date, style: EsmorgaTextStyle.body1Accent),
          const SizedBox(height: 8),
          if ((ui.maxCapacity != null && ui.maxCapacity! > 0) || ui.currentAttendeeCount > 0) ...[
            Row(
              children: [
                if (ui.maxCapacity != null && ui.maxCapacity! > 0) ...[
                  const Icon(Icons.people, size: 20),
                  const SizedBox(width: 8),
                  EsmorgaText(
                    text: l10n.labelCapacity(ui.currentAttendeeCount, ui.maxCapacity!),
                    style: EsmorgaTextStyle.body1Accent,
                  ),
                  const Spacer(),
                ],
                if (ui.currentAttendeeCount > 0 && ui.showViewAttendants)
                  InkWell(
                    onTap: () {
                      context.push('/event_attendees/${ui.id}');
                    },
                    child: EsmorgaText(
                      text: l10n.button_view_attendees,
                      style: EsmorgaTextStyle.button,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          EsmorgaText(
            text: l10n.screen_event_details_join_deadline(ui.joinDeadLine),
            style: EsmorgaTextStyle.caption,
          ),
          const SizedBox(height: 24),
          EsmorgaText(
              text: l10n.screenEventDetailsDescription,
              style: EsmorgaTextStyle.heading2),
          const SizedBox(height: 8),
          EsmorgaText(
              text: safeDecode(ui.description), style: EsmorgaTextStyle.body1),
          const SizedBox(height: 24),
          EsmorgaText(
              text: l10n.screenEventDetailsLocation,
              style: EsmorgaTextStyle.heading2),
          const SizedBox(height: 8),
          EsmorgaText(text: ui.locationName, style: EsmorgaTextStyle.body1),
          if (ui.showNavigateButton) ...[
            const SizedBox(height: 24),
            EsmorgaButton(
              text: l10n.buttonNavigate,
              primary: false,
              onClick: () => _cubit.navigatePressed(),
              key: const Key('event_detail_navigate_button'),
            ),
          ],
          const SizedBox(height: 24),
          
          EsmorgaButton(
            text: ui.buttonText,
            isLoading: state.joinLeaving,
            isEnabled: ui.buttonEnabled,
            onClick: () => _cubit.primaryPressed(),
            key: const Key('event_detail_primary_button'),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _openMaps(double lat, double lng, String name) async {
    final query = Uri.encodeComponent(name);
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng($query)');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps')),
      );
    }
  }
}