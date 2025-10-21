// filepath: lib/view/events/event_detail/view/event_detail_screen_v2.dart

import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<EventDetailCubit>(param1: ctx, param2: eventId),
      child: _EventDetailForm(eventId: eventId),
    );
  }
}

class _EventDetailForm extends StatefulWidget {
  final String eventId;
  const _EventDetailForm({Key? key, required this.eventId}) : super(key: key);

  @override
  State<_EventDetailForm> createState() => _EventDetailFormState();
}

class _EventDetailFormState extends State<_EventDetailForm> {
  @override
  void initState() {
    super.initState();
    context.read<EventDetailCubit>().start();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocConsumer<EventDetailCubit, EventDetailState>(
      listenWhen: (prev, curr) => prev.effectId != curr.effectId && curr.effectType != null,
      listener: (context, state) {
        switch (state.effectType) {
          case EventDetailEffectType.navigateBack:
            context.pop();
            break;
          case EventDetailEffectType.navigateToLogin:
            context.go(AppRoutes.login);
            break;
          case EventDetailEffectType.showJoinSuccess:
            _showSnack(l.snackbarEventJoined);
            break;
          case EventDetailEffectType.showLeaveSuccess:
            _showSnack(l.snackbarEventLeft);
            break;
          case EventDetailEffectType.showNoNetwork:
            _showSnack(l.snackbarNoInternet);
            break;
          case EventDetailEffectType.showGenericError:
            _showSnack(l.defaultErrorTitle);
            break;
          case EventDetailEffectType.openMaps:
            if (state.effectLat != null && state.effectLng != null && state.effectName != null) {
              _openMaps(state.effectLat!, state.effectLng!, state.effectName!);
            }
            break;
          case null:
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.read<EventDetailCubit>().backPressed(),
            ),
          ),
          body: _buildBody(context, state, l),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, EventDetailState state, AppLocalizations l) {
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
            Text(l.defaultErrorTitle),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<EventDetailCubit>().start(),
              child: Text(l.buttonRetry),
            )
          ],
        ),
      );
    }
    final e = state.event;
    if (e == null) {
      // Should rarely happen (just after init) – show placeholder
      return const Center(child: CircularProgressIndicator());
    }
    final formatter = DateFormat.yMMMMd().add_Hm();
    final dateStr = formatter.format(DateTime.fromMillisecondsSinceEpoch(e.date));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              e.imageUrl ?? '',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 200,
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Icon(
                  Icons.event_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          EsmorgaText(
            text: e.name,
            style: EsmorgaTextStyle.heading1,
            key: const Key('event_detail_title'),
          ),
          const SizedBox(height: 8),
          EsmorgaText(text: dateStr, style: EsmorgaTextStyle.body1Accent),
          const SizedBox(height: 8),
          EsmorgaText(text: e.location.name, style: EsmorgaTextStyle.body1Accent),
          const SizedBox(height: 24),
          EsmorgaText(text: l.screenEventDetailsDescription, style: EsmorgaTextStyle.heading2),
          const SizedBox(height: 8),
          EsmorgaText(text: safeDecode(e.description), style: EsmorgaTextStyle.body1),
          const SizedBox(height: 24),
          EsmorgaText(text: l.screenEventDetailsLocation, style: EsmorgaTextStyle.heading2),
          const SizedBox(height: 8),
          EsmorgaText(text: e.location.name, style: EsmorgaTextStyle.body1),
          if (e.location.lat != null && e.location.long != null) ...[
            const SizedBox(height: 24),
            EsmorgaButton(
              text: l.buttonNavigate,
              primary: false,
              onClick: () => context.read<EventDetailCubit>().navigatePressed(),
              key: const Key('event_detail_navigate_button'),
            ),
          ],
          const SizedBox(height: 24),
          EsmorgaButton(
            text: state.isAuthenticated ? (e.userJoined ? l.buttonLeaveEvent : l.buttonJoinEvent) : l.buttonLoginToJoin,
            isLoading: state.joinLeaving,
            onClick: () => context.read<EventDetailCubit>().primaryPressed(),
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
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng($query)');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps')),
      );
    }
  }
}

