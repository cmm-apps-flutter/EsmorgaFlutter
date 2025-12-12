import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_checkbox_row.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_cubit.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_state.dart';
import 'package:esmorga_flutter/ds/esmorga_full_screen_error.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';

class EventAttendeesScreen extends StatelessWidget {
  final String eventId;
  const EventAttendeesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    context.read<EventAttendeesCubit>().loadAttendees(eventId);
    return _EventAttendeesForm(eventId: eventId);
  }
}

class _EventAttendeesForm extends StatelessWidget {
  final String eventId;

  const _EventAttendeesForm({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;
    final cubit = context.read<EventAttendeesCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<EventAttendeesCubit, EventAttendeesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return EsmorgaFullScreenError(
              title: l10n.defaultErrorTitle,
              buttonText: l10n.buttonRetry,
              buttonAction: () =>
                  context.read<EventAttendeesCubit>().loadAttendees(eventId),
            );
          }

          final attendees = state.attendees!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EsmorgaText(
                  text: l10n.titleEventAttendees,
                  style: EsmorgaTextStyle.title,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: EsmorgaText(
                        text: l10n.titleName, 
                        style: EsmorgaTextStyle.heading2,
                      ),
                    ),
                    if (attendees.isAdmin)
                      Padding(
                        padding: const EdgeInsets.only(right:0), 
                        child: EsmorgaText(
                          text: l10n.titlePaymentStatus,
                          style: EsmorgaTextStyle.heading2,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 34),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendees.users.length,
                  itemBuilder: (_, index) {
                    final user = attendees.users[index];
                    return Column(
                      key: ValueKey(user.name),
                      children: [
                        Divider(height: 1, thickness: 1, color:Theme.of(context).colorScheme.secondary),
                        const SizedBox(height: 8),
                        EsmorgaCheckboxRow(
                          text: '${index + 1}. ${user.name}',
                          showCheckbox: attendees.isAdmin,
                          isSelected: user.isPaid,
                          onTap: () { 
                            if (attendees.isAdmin) {
                              cubit.togglePaidStatus(user.name, eventId);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        if (index == attendees.users.length - 1)
                        Divider(height: 1, thickness: 1,color: Theme.of(context).colorScheme.secondary,),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
        },
      ),
    );
  }
}