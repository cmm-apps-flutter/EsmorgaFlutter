import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_cubit.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_state.dart';
import 'package:esmorga_flutter/view/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockProfileCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockProfileCubit();
    localizationService = MockLocalizationService();
    getIt.registerFactory<ProfileCubit>(() => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.start()).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return ProfileScreen(
      onNavigateToLogin: () {},
      onNavigateToChangePassword: () {},
    );
  }

  const user = User(
    name: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    role: RoleType.user,
  );

  screenshotGolden(
    'profile_logged_in',
    theme: lightTheme,
    screenshotPath: 'profile',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ProfileState(
        user: user,
        status: ProfileStatus.loaded,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'profile_logged_out',
    theme: lightTheme,
    screenshotPath: 'profile',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ProfileState(
        user: null,
        status: ProfileStatus.loaded,
      ));
      return buildScreen();
    },
  );
}
