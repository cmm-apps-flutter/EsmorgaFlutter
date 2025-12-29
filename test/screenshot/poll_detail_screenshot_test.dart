import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_cubit.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_state.dart';
import 'package:esmorga_flutter/view/poll_detail/view/poll_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockPollDetailCubit extends MockCubit<PollDetailState> implements PollDetailCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

class MockDateTimeFormatter extends Mock implements EsmorgaDateTimeFormatter {}

void main() {
  late MockPollDetailCubit cubit;
  late MockLocalizationService localizationService;
  late MockDateTimeFormatter dateTimeFormatter;

  setUp(() {
    cubit = MockPollDetailCubit();
    localizationService = MockLocalizationService();
    dateTimeFormatter = MockDateTimeFormatter();

    getIt.registerFactoryParam<PollDetailCubit, Poll, void>((poll, _) => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    getIt.registerSingleton<EsmorgaDateTimeFormatter>(dateTimeFormatter);

    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => dateTimeFormatter.formatEventDate(any())).thenReturn('Oct 12, 10:00 AM');
    when(() => cubit.clearSuccessMessage()).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  final poll = Poll(
    id: '1',
    name: 'Friday Activity',
    description: 'What should we do this Friday?',
    options: [
      PollOption(id: '1', option: 'Bowling', voteCount: 5),
      PollOption(id: '2', option: 'Karaoke', voteCount: 3),
    ],
    userSelectedOptionIds: [],
    voteDeadline: DateTime.now().add(const Duration(days: 1)),
    isMultipleChoice: false,
    imageUrl: 'https://example.com/poll.jpg',
  );

  Widget buildScreen() {
    return PollDetailScreen(poll: poll);
  }

  screenshotGolden(
    'poll_detail_single_choice',
    theme: lightTheme,
    screenshotPath: 'poll_detail',
    buildHome: () {
      when(() => cubit.state).thenReturn(PollDetailState(
        poll: poll,
        currentSelection: const [],
        buttonText: 'Vote',
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'poll_detail_multiple_choice',
    theme: lightTheme,
    screenshotPath: 'poll_detail',
    buildHome: () {
      final multiPoll = Poll(
        id: '1',
        name: 'Multiple Options',
        description: 'Pick all that apply',
        options: poll.options,
        userSelectedOptionIds: ['1'],
        voteDeadline: poll.voteDeadline,
        isMultipleChoice: true,
      );

      // Need to re-register cubit/param if using factory param?
      // PollDetailScreen creates cubit with param1: poll.
      // Our mock setups returns 'cubit' regardless of param.
      // But we need to update state to reflect the NEW poll.

      when(() => cubit.state).thenReturn(PollDetailState(
        poll: multiPoll,
        currentSelection: const ['1'],
        buttonText: 'Change my vote',
        isButtonEnabled: true,
      ));
      return PollDetailScreen(poll: multiPoll);
    },
  );

  screenshotGolden(
    'poll_detail_deadline_passed',
    theme: lightTheme,
    screenshotPath: 'poll_detail',
    buildHome: () {
      final passedPoll = Poll(
        id: '1',
        name: 'Past Poll',
        description: 'This poll is closed',
        options: poll.options,
        userSelectedOptionIds: [],
        voteDeadline: DateTime.now().subtract(const Duration(days: 1)),
        isMultipleChoice: false,
      );

      when(() => cubit.state).thenReturn(PollDetailState(
        poll: passedPoll,
        currentSelection: const [],
        buttonText: 'Too late',
      ));
      return PollDetailScreen(poll: passedPoll);
    },
  );
}
