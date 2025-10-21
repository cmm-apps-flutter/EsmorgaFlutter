import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_cubit.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_effect.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_state.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late _MockUserRepository userRepository;
  late FormValidator validator;
  final l10n = AppLocalizationsEn();
  late _MockLocalizationService mockL10nService;

  setUp(() {
    mockL10nService = _MockLocalizationService();
    getIt.registerSingleton<LocalizationService>(mockL10nService);
    userRepository = _MockUserRepository();
    when(() => mockL10nService.current).thenReturn(l10n);
    validator = FormValidator();
  });

  tearDown(() {
    getIt.reset();
  });

  const validCurrent = 'Current1!';
  const validNew = 'NewPass1!';
  const validRepeat = 'NewPass1!';

  void fillValidFields(ChangePasswordCubit cubit) {
    cubit.onCurrentChanged(validCurrent);
    cubit.onNewChanged(validNew);
    cubit.onRepeatChanged(validRepeat);
  }

  group('ChangePasswordCubit', () {
    test('initial state is ChangePasswordInitial', () {
      final cubit = ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      );
      expect(cubit.state, isA<ChangePasswordInitial>());
    });

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'onCurrentChanged updates currentPassword and validates when touched',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) {
        cubit.onCurrentChanged('test');
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.currentPassword, 'currentPassword', 'test')
            .having((s) => s.currentErrorKey, 'currentErrorKey', null),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'onNewChanged updates newPassword and validates when touched',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) {
        cubit.onNewChanged('newpass');
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.newPassword, 'newPassword', 'newpass')
            .having((s) => s.newErrorKey, 'newErrorKey', null),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'onRepeatChanged updates repeatPassword and validates when touched',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) {
        cubit.onRepeatChanged('repeat');
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.repeatPassword, 'repeatPassword', 'repeat')
            .having((s) => s.repeatErrorKey, 'repeatErrorKey', null),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'onCurrentUnfocused marks field as touched and validates',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) {
        cubit.onCurrentUnfocused();
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.currentTouched, 'currentTouched', true)
            .having((s) => s.currentErrorKey, 'currentErrorKey', isNotNull),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'onNewUnfocused marks field as touched and validates',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) {
        cubit.onNewUnfocused();
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.newTouched, 'newTouched', true)
            .having((s) => s.newErrorKey, 'newErrorKey', isNotNull),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'onRepeatUnfocused marks field as touched and validates',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) {
        cubit.onRepeatUnfocused();
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.repeatTouched, 'repeatTouched', true)
            .having((s) => s.repeatErrorKey, 'repeatErrorKey', isNotNull),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit does nothing when state is not ChangePasswordEditing',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) => cubit.submit(),
      expect: () => [],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit validates all fields and does not proceed if invalid',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) async {
        cubit.onCurrentChanged('');
        cubit.onNewChanged('');
        cubit.onRepeatChanged('');
        await cubit.submit();
      },
      expect: () => contains(
        isA<ChangePasswordEditing>()
            .having((s) => s.currentTouched, 'currentTouched', true)
            .having((s) => s.newTouched, 'newTouched', true)
            .having((s) => s.repeatTouched, 'repeatTouched', true)
            .having((s) => s.isValid, 'isValid', false),
      ),
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit successfully changes password and emits success effect',
      build: () {
        when(() => userRepository.changePassword(any(), any())).thenAnswer((_) async {});
        return ChangePasswordCubit(
          userRepository: userRepository,
          validator: validator,
        );
      },
      act: (cubit) async {
        final effectFuture = expectLater(
          cubit.effects,
          emits(
            isA<ShowSnackbarEffect>()
                .having((e) => e.message, 'message', l10n.passwordSetSnackbar)
                .having((e) => e.success, 'success', true),
          ),
        );
        fillValidFields(cubit);
        await cubit.submit();
        await effectFuture;
      },
      expect: () => contains(
        isA<ChangePasswordEditing>().having((s) => s.isSubmitting, 'isSubmitting', true),
      ),
      verify: (cubit) {
        verify(() => userRepository.changePassword(validCurrent, validNew)).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit handles network error and emits error effect',
      build: () {
        when(() => userRepository.changePassword(any(), any())).thenThrow(Exception('network issue'));
        return ChangePasswordCubit(
          userRepository: userRepository,
          validator: validator,
        );
      },
      act: (cubit) async {
        final effectFuture = expectLater(
          cubit.effects,
          emits(
            isA<ShowSnackbarEffect>().having((e) => e.message, 'message', l10n.snackbarNoInternet),
          ),
        );
        fillValidFields(cubit);
        await cubit.submit();
        await effectFuture;
      },
      verify: (cubit) {
        verify(() => userRepository.changePassword(validCurrent, validNew)).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit handles unauthorized error and emits error effect',
      build: () {
        when(() => userRepository.changePassword(any(), any())).thenThrow(Exception('401 unauthorized'));
        return ChangePasswordCubit(
          userRepository: userRepository,
          validator: validator,
        );
      },
      act: (cubit) async {
        final effectFuture = expectLater(
          cubit.effects,
          emits(
            isA<ShowSnackbarEffect>().having((e) => e.message, 'message', l10n.unauthenticatedErrorMessage),
          ),
        );
        fillValidFields(cubit);
        await cubit.submit();
        await effectFuture;
      },
      verify: (cubit) {
        verify(() => userRepository.changePassword(validCurrent, validNew)).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'submit handles generic error and emits error effect',
      build: () {
        when(() => userRepository.changePassword(any(), any())).thenThrow(Exception('something went wrong'));
        return ChangePasswordCubit(
          userRepository: userRepository,
          validator: validator,
        );
      },
      act: (cubit) async {
        final effectFuture = expectLater(
          cubit.effects,
          emits(
            isA<ShowSnackbarEffect>().having((e) => e.message, 'message', l10n.defaultErrorTitle),
          ),
        );
        fillValidFields(cubit);
        await cubit.submit();
        await effectFuture;
      },
      verify: (cubit) {
        verify(() => userRepository.changePassword(validCurrent, validNew)).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'validates that new password is different from current password',
      build: () => ChangePasswordCubit(
        userRepository: userRepository,
        validator: validator,
      ),
      act: (cubit) {
        cubit.onCurrentChanged(validCurrent);
        cubit.onNewChanged(validCurrent);
        cubit.onNewUnfocused();
      },
      expect: () => contains(
        isA<ChangePasswordEditing>()
            .having((s) => s.newErrorKey, 'newErrorKey', l10n.registrationReusedPasswordError),
      ),
    );
  });
}
