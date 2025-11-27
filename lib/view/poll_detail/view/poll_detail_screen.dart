import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_checkbox_row.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_cubit.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PollDetailScreen extends StatelessWidget {
  final Poll poll;

  const PollDetailScreen({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PollDetailCubit>(param1: poll),
      child: const _PollDetailView(),
    );
  }
}

class _PollDetailView extends StatelessWidget {
  const _PollDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;
    final cubit = context.read<PollDetailCubit>();

    return BlocListener<PollDetailCubit, PollDetailState>(
      listenWhen: (previous, current) =>
          current.showSuccessMessage && !previous.showSuccessMessage ||
          current.error != null && current.error != previous.error,
      listener: (context, state) {
        if (state.showSuccessMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.snackbarVoteSuccessful)),
          );
          cubit.clearSuccessMessage();
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<PollDetailCubit, PollDetailState>(
          builder: (context, state) {
            final poll = state.poll;
            final formatter = getIt<EsmorgaDateTimeFormatter>();
            final isDeadlinePassed = DateTime.now().isAfter(poll.voteDeadline);
            final hasVoted = poll.userSelectedOptionIds.isNotEmpty;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (poll.imageUrl != null && poll.imageUrl!.isNotEmpty)
                    Image.network(
                      poll.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/poll_placeholder.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Image.asset(
                      'assets/images/poll_placeholder.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EsmorgaText(
                          text: poll.name,
                          style: EsmorgaTextStyle.heading1,
                        ),
                        const SizedBox(height: 8),
                        EsmorgaText(
                          text:
                              '${l10n.textPollVoteDeadline} ${formatter.formatEventDate(poll.voteDeadline.millisecondsSinceEpoch)}',
                          style: EsmorgaTextStyle.body1Accent,
                        ),
                        const SizedBox(height: 24),
                        EsmorgaText(
                          text: l10n.titleInfo,
                          style: EsmorgaTextStyle.heading2,
                        ),
                        const SizedBox(height: 8),
                        EsmorgaText(
                          text: poll.description,
                          style: EsmorgaTextStyle.body1,
                        ),
                        const SizedBox(height: 24),
                        if (poll.isMultipleChoice)
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                bottom: BorderSide(color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: poll.options.length,
                              separatorBuilder: (context, index) => Divider(
                                color: Theme.of(context).colorScheme.secondary,
                                height: 1,
                              ),
                              itemBuilder: (context, index) {
                                final option = poll.options[index];
                                final isSelected = state.currentSelection.contains(option.id);
                                return EsmorgaCheckboxRow(
                                  text: '${option.option} ${l10n.textPollVoteCount(option.voteCount)}',
                                  isSelected: isSelected,
                                  onTap: isDeadlinePassed ? null : () => cubit.toggleOption(option.id),
                                );
                              },
                            ),
                          )
                        else
                          RadioGroup<String>(
                            groupValue: state.currentSelection.isNotEmpty ? state.currentSelection.first : null,
                            onChanged: (value) {
                              if (!isDeadlinePassed && value != null) {
                                cubit.toggleOption(value);
                              }
                            },
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: poll.options.length,
                              itemBuilder: (context, index) {
                                final option = poll.options[index];
                                return InkWell(
                                  onTap: isDeadlinePassed ? null : () => cubit.toggleOption(option.id),
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: option.id,
                                        fillColor: WidgetStateProperty.resolveWith((states) {
                                          if (states.contains(WidgetState.selected)) {
                                            return Theme.of(context).colorScheme.primary;
                                          }
                                          return Theme.of(context).colorScheme.secondary;
                                        }),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: EsmorgaText(
                                          text: '${option.option} ${l10n.textPollVoteCount(option.voteCount)}',
                                          style: EsmorgaTextStyle.body1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 24),
                        EsmorgaButton(
                          text: isDeadlinePassed
                              ? l10n.buttonDeadlinePassed
                              : (hasVoted ? l10n.buttonPollChangeVote : l10n.buttonPollVote),
                          isEnabled: !isDeadlinePassed && state.currentSelection.isNotEmpty,
                          isLoading: state.isLoading,
                          onClick: () => cubit.vote(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
