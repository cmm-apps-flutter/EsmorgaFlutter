import 'package:esmorga_flutter/view/login/cubit/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginState.copyWith retain behavior', () {
    test('retains emailError when parameter omitted', () {
      const initial = LoginState(emailError: 'Required');
      expect(initial.copyWith().emailError, 'Required');
    });

    test('retains passwordError when parameter omitted', () {
      const initial = LoginState(passwordError: 'Too short');
      expect(initial.copyWith().passwordError, 'Too short');
    });

    test('retains failureMessage when parameter omitted', () {
      const initial = LoginState(failureMessage: 'Network error');
      expect(initial.copyWith().failureMessage, 'Network error');
    });

    test('retains initMessage when parameter omitted', () {
      const initial = LoginState(initMessage: 'Welcome back');
      expect(initial.copyWith().initMessage, 'Welcome back');
    });
  });

  group('LoginState.withValidationResult', () {
    test('clears emailError when null is passed', () {
      const initial = LoginState(emailError: 'Required', passwordError: 'Too short');
      expect(
        initial.withValidationResult(emailError: null, passwordError: initial.passwordError).emailError,
        isNull,
      );
    });

    test('replaces emailError with new value', () {
      const initial = LoginState(emailError: 'Required');
      expect(
        initial.withValidationResult(emailError: 'Invalid', passwordError: null).emailError,
        'Invalid',
      );
    });

    test('clears passwordError when null is passed', () {
      const initial = LoginState(emailError: 'Required', passwordError: 'Too short');
      expect(
        initial.withValidationResult(emailError: initial.emailError, passwordError: null).passwordError,
        isNull,
      );
    });
  });

  group('LoginState.clearInitMessage', () {
    test('clears initMessage', () {
      const initial = LoginState(initMessage: 'Welcome back');
      expect(initial.clearInitMessage().initMessage, isNull);
    });

    test('preserves all other fields', () {
      const initial = LoginState(email: 'a@b.com', initMessage: 'Welcome back', failureMessage: 'Error');
      final cleared = initial.clearInitMessage();
      expect(cleared.email, 'a@b.com');
      expect(cleared.failureMessage, 'Error');
    });
  });
}
