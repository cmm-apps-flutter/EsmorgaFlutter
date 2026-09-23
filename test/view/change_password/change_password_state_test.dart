import 'package:esmorga_flutter/view/change_password/cubit/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordEditing.copyWith retain behavior', () {
    test('retains currentErrorKey when parameter omitted', () {
      const initial = ChangePasswordEditing(currentErrorKey: 'required');
      expect(initial.copyWith().currentErrorKey, 'required');
    });

    test('retains newErrorKey when parameter omitted', () {
      const initial = ChangePasswordEditing(newErrorKey: 'too_short');
      expect(initial.copyWith().newErrorKey, 'too_short');
    });

    test('retains repeatErrorKey when parameter omitted', () {
      const initial = ChangePasswordEditing(repeatErrorKey: 'mismatch');
      expect(initial.copyWith().repeatErrorKey, 'mismatch');
    });
  });

  group('ChangePasswordEditing.withValidationResult', () {
    const base = ChangePasswordEditing(
      currentErrorKey: 'required',
      newErrorKey: 'too_short',
      repeatErrorKey: 'mismatch',
    );

    test('clears currentErrorKey when null is passed', () {
      expect(
        base.withValidationResult(
          currentErrorKey: null,
          newErrorKey: base.newErrorKey,
          repeatErrorKey: base.repeatErrorKey,
        ).currentErrorKey,
        isNull,
      );
    });

    test('clears newErrorKey when null is passed', () {
      expect(
        base.withValidationResult(
          currentErrorKey: base.currentErrorKey,
          newErrorKey: null,
          repeatErrorKey: base.repeatErrorKey,
        ).newErrorKey,
        isNull,
      );
    });

    test('clears repeatErrorKey when null is passed', () {
      expect(
        base.withValidationResult(
          currentErrorKey: base.currentErrorKey,
          newErrorKey: base.newErrorKey,
          repeatErrorKey: null,
        ).repeatErrorKey,
        isNull,
      );
    });

    test('replaces currentErrorKey with new value', () {
      expect(
        base.withValidationResult(
          currentErrorKey: 'wrong',
          newErrorKey: base.newErrorKey,
          repeatErrorKey: base.repeatErrorKey,
        ).currentErrorKey,
        'wrong',
      );
    });
  });
}
