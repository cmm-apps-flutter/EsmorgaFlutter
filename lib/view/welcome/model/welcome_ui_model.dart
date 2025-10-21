import 'package:equatable/equatable.dart';

class WelcomeUiState extends Equatable {
  final String primaryButtonText;
  final String secondaryButtonText;
  final String icon;

  const WelcomeUiState({
    this.primaryButtonText = '',
    this.secondaryButtonText = '',
    this.icon = 'assets/icons/ic_logo.png',
  });

  WelcomeUiState copyWith({
    String? primaryButtonText,
    String? secondaryButtonText,
    String? icon,
  }) {
    return WelcomeUiState(
      primaryButtonText: primaryButtonText ?? this.primaryButtonText,
      secondaryButtonText: secondaryButtonText ?? this.secondaryButtonText,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [primaryButtonText, secondaryButtonText, icon];
}

sealed class WelcomeEffect {}

class NavigateToEventList extends WelcomeEffect {}

class NavigateToLogin extends WelcomeEffect {}

