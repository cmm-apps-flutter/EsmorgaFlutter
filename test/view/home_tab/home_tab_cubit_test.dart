import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/usecase/get_polls_use_case.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_cubit.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_state.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements EventRepository {}

class MockGetPollsUseCase extends Mock implements GetPollsUseCase {}

class MockUserRepository extends Mock implements UserRepository {}

class MockLocalizationService extends Mock implements LocalizationService {}

class FakeFormatter implements EsmorgaDateTimeFormatter {
  @override
  String formatEventDate(int epochMillis) => 'formattedDate';

  @override
  String formatIsoDateTime(DateTime date, String time) => 'iso';

  @override
  String formatTimeWithMillisUtcSuffix(int hour, int minute) => 'timeZ';
}

final event = Event(
  id: '1',
  name: 'Event 1',
  date: DateTime(2025, 1, 1).millisecondsSinceEpoch,
  description: 'desc',
  imageUrl: 'https://image',
  location: const EventLocation(name: 'Location'),
  tags: const [],
  userJoined: false,
  currentAttendeeCount: 2,
  maxCapacity: 10,
  joinDeadline: DateTime(2025, 1, 1).millisecondsSinceEpoch,
);

final poll = Poll(
  id: '1',
  name: 'Poll 1',
  description: 'desc',
  options: const [],
  userSelectedOptionIds: const [],
  voteDeadline: DateTime(2025, 1, 1),
  isMultipleChoice: false,
);

final user = User(
  name: 'User',
  lastName: 'Test',
  email: 'email@test.com',
  role: RoleType.user,
);

void main() {
  late MockEventRepository eventRepository;
  late MockGetPollsUseCase getPollsUseCase;
  late MockUserRepository userRepository;
  late MockLocalizationService mockLocalizationService;
  final l10n = AppLocalizationsEn();

  setUp(() {
    eventRepository = MockEventRepository();
    getPollsUseCase = MockGetPollsUseCase();
    userRepository = MockUserRepository();
    mockLocalizationService = MockLocalizationService();

    getIt.registerSingleton<EsmorgaDateTimeFormatter>(FakeFormatter());
    getIt.registerSingleton<LocalizationService>(mockLocalizationService);
    when(() => mockLocalizationService.current).thenReturn(l10n);
  });

  tearDown(() async {
    reset(eventRepository);
    reset(getPollsUseCase);
    reset(userRepository);
    getIt.reset();
  });

  blocTest<HomeTabCubit, HomeTabState>(
    'emits [loading true, then success with events and polls] when authenticated and repositories return data',
    build: () {
      when(() => eventRepository.getEvents()).thenAnswer((_) async => [event]);
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      when(() => getPollsUseCase()).thenAnswer((_) async => [poll]);
      return HomeTabCubit(
        eventRepository: eventRepository,
        getPollsUseCase: getPollsUseCase,
        userRepository: userRepository,
      );
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<HomeTabState>().having((s) => s.loading, 'loading', true),
      isA<HomeTabState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.eventList.length, 'event count', 1)
          .having((s) => s.pollList.length, 'poll count', 1)
          .having((s) => s.error, 'error', null),
    ],
  );

  blocTest<HomeTabCubit, HomeTabState>(
    'emits [loading true, then success with events and empty polls] when unauthenticated',
    build: () {
      when(() => eventRepository.getEvents()).thenAnswer((_) async => [event]);
      when(() => userRepository.getUser()).thenThrow(Exception('Not authenticated'));
      return HomeTabCubit(
        eventRepository: eventRepository,
        getPollsUseCase: getPollsUseCase,
        userRepository: userRepository,
      );
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<HomeTabState>().having((s) => s.loading, 'loading', true),
      isA<HomeTabState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.eventList.length, 'event count', 1)
          .having((s) => s.pollList.length, 'poll count', 0)
          .having((s) => s.error, 'error', null),
    ],
    verify: (_) {
      verifyNever(() => getPollsUseCase());
    },
  );

  blocTest<HomeTabCubit, HomeTabState>(
    'emits [loading true, then empty lists] when repositories return empty lists',
    build: () {
      when(() => eventRepository.getEvents()).thenAnswer((_) async => []);
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      when(() => getPollsUseCase()).thenAnswer((_) async => []);
      return HomeTabCubit(
        eventRepository: eventRepository,
        getPollsUseCase: getPollsUseCase,
        userRepository: userRepository,
      );
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<HomeTabState>().having((s) => s.loading, 'loading', true),
      isA<HomeTabState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.eventList.length, 'event count', 0)
          .having((s) => s.pollList.length, 'poll count', 0)
          .having((s) => s.error, 'error', null),
    ],
  );

  blocTest<HomeTabCubit, HomeTabState>(
    'emits [loading true, then error + showNoNetworkPrompt] when event repository throws network error',
    build: () {
      when(() => eventRepository.getEvents()).thenThrow(Exception('network error'));
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      when(() => getPollsUseCase()).thenAnswer((_) async => []);
      return HomeTabCubit(
        eventRepository: eventRepository,
        getPollsUseCase: getPollsUseCase,
        userRepository: userRepository,
      );
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<HomeTabState>().having((s) => s.loading, 'loading', true),
      isA<HomeTabState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.error, 'error', contains('network error'))
          .having((s) => s.showNoNetworkPrompt, 'showNoNetworkPrompt', true),
    ],
  );

  blocTest<HomeTabCubit, HomeTabState>(
    'emits [loading true, then error] when poll usecase throws error',
    build: () {
      when(() => eventRepository.getEvents()).thenAnswer((_) async => [event]);
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      when(() => getPollsUseCase()).thenThrow(Exception('poll error'));
      return HomeTabCubit(
        eventRepository: eventRepository,
        getPollsUseCase: getPollsUseCase,
        userRepository: userRepository,
      );
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<HomeTabState>().having((s) => s.loading, 'loading', true),
      isA<HomeTabState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.error, 'error', contains('poll error')),
    ],
  );
}
