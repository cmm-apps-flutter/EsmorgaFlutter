part of 'splash_cubit.dart';

class SplashState {
  final bool completed;
  const SplashState._(this.completed);

  const SplashState.initial() : this._(false);
  const SplashState.completed() : this._(true);
}

