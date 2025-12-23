import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_cubit.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_state.dart';
import 'package:esmorga_flutter/view/home_tab/model/home_tab_ui_model.dart';
import 'package:esmorga_flutter/view/home_tab/model/poll_ui_model.dart';
import 'package:esmorga_flutter/view/home_tab/view/home_tab_screen.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockHomeTabCubit extends MockCubit<HomeTabState> implements HomeTabCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockHomeTabCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockHomeTabCubit();
    localizationService = MockLocalizationService();
    getIt.registerFactory<HomeTabCubit>(() => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.effects).thenAnswer((_) => const Stream.empty());
    when(() => cubit.loadEvents()).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return HomeTabScreen(
      onDetailsClicked: (_) async {},
      onPollClicked: (_) async {},
    );
  }

  final events = [
    const HomeTabUiModel(
      id: '1',
      cardTitle: 'Tech Talk',
      cardSubtitle1: '12th Oct, 18:00',
      cardSubtitle2: 'Main Hall',
      imageUrl: 'https://example.com/image1.jpg',
    ),
    const HomeTabUiModel(
      id: '2',
      cardTitle: 'Networking Night',
      cardSubtitle1: '13th Oct, 20:00',
      cardSubtitle2: 'Rooftop Bar',
      imageUrl: 'https://example.com/image2.jpg',
    ),
  ];

  final polls = [
    const PollUiModel(
      id: '101',
      title: 'Next Event Topic?',
      deadline: 'Ends in 2 days',
      imageUrl: 'https://example.com/poll1.jpg',
    ),
  ];

  screenshotGolden(
    'home_tab_content',
    theme: lightTheme,
    screenshotPath: 'home_tab',
    buildHome: () {
      when(() => cubit.state).thenReturn(HomeTabState(
        eventList: events,
        pollList: polls,
        loading: false,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'home_tab_empty',
    theme: lightTheme,
    screenshotPath: 'home_tab',
    buildHome: () {
      when(() => cubit.state).thenReturn(const HomeTabState(
        eventList: [],
        pollList: [],
        loading: false,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'home_tab_error',
    theme: lightTheme,
    screenshotPath: 'home_tab',
    buildHome: () {
      when(() => cubit.state).thenReturn(const HomeTabState(
        error: 'Something went wrong',
        loading: false,
      ));
      return buildScreen();
    },
  );
}
