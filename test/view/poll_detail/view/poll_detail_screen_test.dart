import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_cubit.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_state.dart';
import 'package:esmorga_flutter/view/poll_detail/view/poll_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockPollDetailCubit extends MockCubit<PollDetailState> implements PollDetailCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

class MockEsmorgaDateTimeFormatter extends Mock implements EsmorgaDateTimeFormatter {}

void main() {
  late MockPollDetailCubit cubit;
  late MockLocalizationService localizationService;
  late MockAppLocalizations appLocalizations;
  late MockEsmorgaDateTimeFormatter formatter;

  final poll = Poll(
    id: '1',
    name: 'Poll 1',
    description: 'desc',
    options: const [
      PollOption(id: 'opt1', option: 'Option 1', voteCount: 0),
      PollOption(id: 'opt2', option: 'Option 2', voteCount: 0),
    ],
    userSelectedOptionIds: const [],
    voteDeadline: DateTime.now().add(const Duration(days: 1)),
    isMultipleChoice: false,
  );

  setUp(() {
    cubit = MockPollDetailCubit();
    localizationService = MockLocalizationService();
    appLocalizations = MockAppLocalizations();
    formatter = MockEsmorgaDateTimeFormatter();

    GetIt.I.registerFactoryParam<PollDetailCubit, Poll, void>((param1, _) => cubit);
    GetIt.I.registerSingleton<LocalizationService>(localizationService);
    GetIt.I.registerSingleton<EsmorgaDateTimeFormatter>(formatter);

    when(() => localizationService.current).thenReturn(appLocalizations);
    when(() => appLocalizations.textPollVoteDeadline).thenReturn('Deadline:');
    when(() => appLocalizations.titleInfo).thenReturn('Info');
    when(() => appLocalizations.textPollVoteCount(any())).thenReturn('(0 votes)');
    when(() => appLocalizations.buttonPollVote).thenReturn('Vote');
    when(() => appLocalizations.buttonPollChangeVote).thenReturn('Change Vote');
    when(() => appLocalizations.buttonDeadlinePassed).thenReturn('Deadline Passed');
    when(() => appLocalizations.snackbarVoteSuccessful).thenReturn('Vote Successful');
    when(() => formatter.formatEventDate(any())).thenReturn('Tomorrow');
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: PollDetailScreen(poll: poll),
    );
  }

  testWidgets('renders poll details correctly', (tester) async {
    when(() => cubit.state).thenReturn(PollDetailState(
      poll: poll,
      buttonText: 'Vote',
      isButtonEnabled: true,
    ));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Poll 1'), findsOneWidget);
    expect(find.text('desc'), findsOneWidget);
    expect(find.text('Deadline: Tomorrow'), findsOneWidget);
    expect(find.text('Info'), findsOneWidget);
    expect(find.text('Option 1 (0 votes)'), findsOneWidget);
    expect(find.text('Option 2 (0 votes)'), findsOneWidget);
    expect(find.text('Vote'), findsOneWidget);
  });

  testWidgets('toggles option when tapped', (tester) async {
    when(() => cubit.state).thenReturn(PollDetailState(poll: poll));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Option 1 (0 votes)'));
    verify(() => cubit.toggleOption('opt1')).called(1);
  });

  testWidgets('shows vote button enabled when option selected', (tester) async {
    when(() => cubit.state).thenReturn(PollDetailState(
      poll: poll,
      currentSelection: ['opt1'],
      buttonText: 'Vote',
      isButtonEnabled: true,
    ));
    when(() => cubit.vote()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Vote');
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    verify(() => cubit.vote()).called(1);
  });

  testWidgets('shows success snackbar when vote is successful', (tester) async {
    whenListen(
      cubit,
      Stream.fromIterable([
        PollDetailState(poll: poll, showSuccessMessage: true),
      ]),
      initialState: PollDetailState(poll: poll),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Process the stream

    expect(find.text('Vote Successful'), findsOneWidget);
    verify(() => cubit.clearSuccessMessage()).called(1);
  });
}
