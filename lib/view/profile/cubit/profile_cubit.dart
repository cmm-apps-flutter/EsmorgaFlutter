import 'package:bloc/bloc.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository userRepository;

  ProfileCubit({required this.userRepository}) : super(const ProfileState());

  Future<void> start() async {
    await _loadUser();
  }

  Future<void> refresh() async {
    await _loadUser();
  }

  Future<void> logoutPressed() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await userRepository.logout();
      emit(state.copyWith(userIsNull: true, status: ProfileStatus.loaded, oneOffAction: ProfileAction.loggedOut));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()));
    }
  }

  void loginPressed() {
    emit(state.copyWith(oneOffAction: ProfileAction.navigateToLogin));
  }

  void changePasswordPressed() {
    emit(state.copyWith(oneOffAction: ProfileAction.navigateToChangePassword));
  }

  void actionConsumed() {
    emit(state.copyWith(clearAction: true));
  }

  Future<void> _loadUser() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true, clearAction: true));
    try {
      final user = await userRepository.getUser();
      emit(state.copyWith(user: user, status: ProfileStatus.loaded));
    } catch (e) {
      emit(state.copyWith(userIsNull: true, status: ProfileStatus.error, errorMessage: e.toString()));
    }
  }
}
