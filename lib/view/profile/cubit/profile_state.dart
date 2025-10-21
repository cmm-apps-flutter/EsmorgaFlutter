import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';

enum ProfileAction { navigateToChangePassword, navigateToLogin, loggedOut }

enum ProfileStatus { idle, loading, loaded, error }

class ProfileState extends Equatable {
  final User? user;
  final ProfileStatus status;
  final String? errorMessage;
  final ProfileAction? oneOffAction; // consumed by UI then cleared

  const ProfileState({
    this.user,
    this.status = ProfileStatus.idle,
    this.errorMessage,
    this.oneOffAction,
  });

  bool get isLoggedIn => user != null;
  bool get isLoading => status == ProfileStatus.loading;

  ProfileState copyWith({
    User? user,
    bool userIsNull = false, // helper flag to explicitly null user
    ProfileStatus? status,
    String? errorMessage,
    bool clearError = false,
    ProfileAction? oneOffAction,
    bool clearAction = false,
  }) {
    return ProfileState(
      user: userIsNull ? null : (user ?? this.user),
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage,
      oneOffAction: clearAction ? null : oneOffAction,
    );
  }

  @override
  List<Object?> get props => [user, status, errorMessage, oneOffAction];
}

