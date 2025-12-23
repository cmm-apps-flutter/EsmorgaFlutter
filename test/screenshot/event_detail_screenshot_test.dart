import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/view/event_detail_screen.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockEventRepository extends Mock implements EventRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockLocalizationService extends Mock implements LocalizationService {}

class FakeFormatter extends EsmorgaDateTimeFormatter {
  @override
  String formatEventDate(int epochMillis) => '27 Oct 2040 fake formatter';

  @override
  String formatIsoDateTime(DateTime date, String time) => 'iso';

  @override
  String formatTimeWithMillisUtcSuffix(int hour, int minute) => 'time';
}

void main() {
  late MockEventRepository eventRepository;
  late MockUserRepository userRepository;
  late MockLocalizationService localizationService;

  setUp(() {
    eventRepository = MockEventRepository();
    userRepository = MockUserRepository();
    localizationService = MockLocalizationService();

    getIt.registerSingleton<EsmorgaDateTimeFormatter>(FakeFormatter());
    getIt.registerSingleton<LocalizationService>(localizationService);

    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  final futureDate = 2240175600000; // 27 Oct 2040

  final baseEvent = Event(
    id: '1',
    name: 'Esmorga Party',
    date: futureDate,
    description: 'Best party ever',
    location: EventLocation(name: 'A Coruña', lat: 43.36, long: -8.41),
    userJoined: false,
    imageUrl: 'https://example.com/image.jpg',
    tags: [],
    currentAttendeeCount: 10,
    maxCapacity: 100,
    joinDeadline: futureDate + 3600000,
  );

  const user = User(
    name: 'Pepe',
    lastName: 'Perez',
    email: 'pepe@test.com',
    role: RoleType.user,
  );

  Widget buildScreen(Event event) {
    return BlocProvider(
      create: (_) => EventDetailCubit(
        eventRepository: eventRepository,
        userRepository: userRepository,
        event: event,
        l10n: localizationService,
      )..start(), // Trigger start to load
      child: EventDetailScreen(
        goToLogin: () {},
        goToAttendees: (_) {},
      ),
    );
  }

  screenshotGolden(
    'event_detail_guest',
    theme: lightTheme,
    screenshotPath: 'event_detail',
    buildHome: () {
      when(() => userRepository.getUser()).thenThrow(Exception('Not auth'));
      return buildScreen(baseEvent);
    },
  );

  screenshotGolden(
    'event_detail_user_available',
    theme: lightTheme,
    screenshotPath: 'event_detail',
    buildHome: () {
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      return buildScreen(baseEvent);
    },
  );

  screenshotGolden(
    'event_detail_user_joined',
    theme: lightTheme,
    screenshotPath: 'event_detail',
    buildHome: () {
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      return buildScreen(baseEvent.copyWith(userJoined: true));
    },
  );

  screenshotGolden(
    'event_detail_user_full',
    theme: lightTheme,
    screenshotPath: 'event_detail',
    buildHome: () {
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      return buildScreen(baseEvent.copyWith(
        currentAttendeeCount: 100,
        maxCapacity: 100,
      ));
    },
  );

  screenshotGolden(
    'event_detail_user_deadline_passed',
    theme: lightTheme,
    screenshotPath: 'event_detail',
    buildHome: () {
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      // Deadline in the past
      return buildScreen(baseEvent.copyWith(
        joinDeadline: DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ));
    },
  );
}
