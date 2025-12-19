import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/home_tab/model/poll_ui_model.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';

extension PollUiMapper on Poll {
  PollUiModel toPollUi() {
    final formatter = getIt<EsmorgaDateTimeFormatter>();
    final l10n = getIt<LocalizationService>().current;

    return PollUiModel(
      id: id,
      title: name,
      deadline: '${l10n.textPollVoteDeadline} ${formatter.formatEventDate(voteDeadline.millisecondsSinceEpoch)}',
      imageUrl: imageUrl,
    );
  }
}

extension PollUiMapperList on List<Poll> {
  List<PollUiModel> toPollUiList() {
    return map((poll) => poll.toPollUi()).toList();
  }
}
