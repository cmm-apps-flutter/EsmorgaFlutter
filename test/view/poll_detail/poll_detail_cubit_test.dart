import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/usecase/vote_poll_use_case.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_cubit.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_state.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVotePollUseCase extends Mock implements VotePollUseCase {}

class _MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockVotePollUseCase votePollUseCase;
  late _MockLocalizationService l10n;

  setUp(() {
    votePollUseCase = MockVotePollUseCase();
    l10n = _MockLocalizationService();
    when(() => l10n.current).thenReturn(AppLocalizationsEn());
  });

  Poll getPoll({bool? multi, List<String>? selectedOptions}) {
    return Poll(
      id: '1',
      name: 'Poll 1',
      description: 'desc',
      options: const [
        PollOption(id: 'opt1', option: 'Option 1', voteCount: 5),
        PollOption(id: 'opt2', option: 'Option 2', voteCount: 3),
      ],
      userSelectedOptionIds: selectedOptions ?? const [],
      voteDeadline: DateTime.now().add(const Duration(days: 1)),
      isMultipleChoice: multi ?? false,
    );
  }

  final poll = getPoll();

  final multiPoll = getPoll(multi: true);

  group('PollDetailCubit', () {
    test('initial state is correct', () {
      final cubit = PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase, l10n: l10n);
      expect(cubit.state.poll, poll);
      expect(cubit.state.currentSelection, isEmpty);
    });

    blocTest<PollDetailCubit, PollDetailState>(
      'toggleOption selects option in single choice',
      build: () => PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase, l10n: l10n),
      act: (cubit) => cubit.toggleOption('opt1'),
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'toggleOption switches option in single choice',
      build: () => PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase, l10n: l10n),
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.toggleOption('opt2');
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt2']),
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'toggleOption adds/removes option in multiple choice',
      build: () => PollDetailCubit(poll: multiPoll, votePollUseCase: votePollUseCase, l10n: l10n),
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.toggleOption('opt2');
        cubit.toggleOption('opt1');
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1', 'opt2']),
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt2']),
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'given successful useCase when user votes then cubit emits success state with button disabled',
      build: () {
        when(() => votePollUseCase(any(), any())).thenAnswer((_) async => getPoll(
              multi: true,
              selectedOptions: const ['opt1'],
            ));
        return PollDetailCubit(poll: multiPoll, votePollUseCase: votePollUseCase, l10n: l10n);
      },
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.vote();
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.isButtonLoading, 'loading', true),
        isA<PollDetailState>()
            .having((s) => s.isButtonLoading, 'loading', false)
            .having((s) => s.showSuccessMessage, 'success', true)
            .having((s) => s.isButtonEnabled, 'button enabled', false)
            .having((s) => s.buttonText, 'button text', l10n.current.buttonPollChangeVote)
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'vote emits loading then error',
      build: () {
        when(() => votePollUseCase(any(), any())).thenThrow(Exception('error'));
        return PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase, l10n: l10n);
      },
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.vote();
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.isButtonLoading, 'loading', true),
        isA<PollDetailState>()
            .having((s) => s.isButtonLoading, 'loading', false)
            .having((s) => s.error, 'error', isNotNull),
      ],
    );
  });
}
