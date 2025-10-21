import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_cubit.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  late _MockUserRepository userRepository;
  const testUser = User(
      name: 'John',
      lastName: 'Doe',
      email: 'john@doe.com',
      role: RoleType.user);

  setUp(() {
    userRepository = _MockUserRepository();
  });

  group('ProfileCubit', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, loaded] with user when start succeeds',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        return ProfileCubit(userRepository: userRepository);
      },
      act: (cubit) async {
        await cubit.start();
      },
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loading),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loaded)
            .having((s) => s.user, 'user', testUser),
      ],
      verify: (_) {
        verify(() => userRepository.getUser()).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, error] when start fails',
      build: () {
        when(() => userRepository.getUser())
            .thenThrow(Exception('cache empty'));
        return ProfileCubit(userRepository: userRepository);
      },
      act: (cubit) async {
        await cubit.start();
      },
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loading),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.error)
            .having((s) => s.user, 'user', isNull),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loggedOut action after successful logout',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        when(() => userRepository.logout()).thenAnswer((_) async {});
        return ProfileCubit(userRepository: userRepository);
      },
      act: (cubit) async {
        await cubit.start();
        await cubit.logoutPressed();
      },
      skip: 0,
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loading),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loaded),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loading),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loaded)
            .having((s) => s.oneOffAction, 'action', ProfileAction.loggedOut)
            .having((s) => s.user, 'user', isNull),
      ],
      verify: (_) {
        verify(() => userRepository.getUser()).called(1);
        verify(() => userRepository.logout()).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits error when logout fails',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        when(() => userRepository.logout())
            .thenThrow(Exception('logout failed'));
        return ProfileCubit(userRepository: userRepository);
      },
      act: (cubit) async {
        await cubit.start();
        await cubit.logoutPressed();
      },
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loading),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loaded),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.loading),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.error)
            .having((s) => s.errorMessage, 'error', contains('logout failed')),
      ],
    );
  });
}
