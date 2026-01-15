import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/events/my_events/cubit/my_events_cubit.dart';
import 'package:esmorga_flutter/view/events/my_events/view/my_events_screen.dart';
import 'package:esmorga_flutter/view/home_tab/model/home_tab_ui_model.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockMyEventsCubit extends MockCubit<MyEventsState>
    implements MyEventsCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockMyEventsCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockMyEventsCubit();
    localizationService = MockLocalizationService();
    getIt.registerFactory<MyEventsCubit>(() => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.load(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async {});
    when(() => cubit.effects).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return MyEventsScreen(
      onDetailsClicked: (_) async => false,
      onSignInClicked: () {},
    );
  }

  final events = [
    const HomeTabUiModel(
      id: '1',
      cardTitle: 'Tech Meetup',
      cardSubtitle1: '12th Oct, 18:00',
      cardSubtitle2: 'Innovation Hub',
      imageUrl: 'https://example.com/image1.jpg',
    ),
  ];

  screenshotGolden(
    'my_events_content',
    theme: lightTheme,
    screenshotPath: 'my_events',
    buildHome: () {
      when(() => cubit.state).thenReturn(MyEventsState(
        eventList: events,
        loading: false,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'my_events_content_admin',
    theme: lightTheme,
    screenshotPath: 'my_events',
    buildHome: () {
      when(() => cubit.state).thenReturn(MyEventsState(
        eventList: events,
        loading: false,
        showCreateButton: true,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'my_events_empty',
    theme: lightTheme,
    screenshotPath: 'my_events',
    buildHome: () {
      when(() => cubit.state).thenReturn(const MyEventsState(
        eventList: [],
        error: MyEventsEffectType.emptyList,
        loading: false,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'my_events_empty_admin',
    theme: lightTheme,
    screenshotPath: 'my_events',
    buildHome: () {
      when(() => cubit.state).thenReturn(const MyEventsState(
        eventList: [],
        error: MyEventsEffectType.emptyList,
        loading: false,
        showCreateButton: true,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'my_events_not_logged_in',
    theme: lightTheme,
    screenshotPath: 'my_events',
    buildHome: () {
      when(() => cubit.state).thenReturn(const MyEventsState(
        error: MyEventsEffectType.notLoggedIn,
        loading: false,
      ));
      return buildScreen();
    },
  );
}
