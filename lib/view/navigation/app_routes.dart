import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/view/change_password/view/change_password_screen.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_cubit.dart';
import 'package:esmorga_flutter/view/event_list/cubit/event_list_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/view/event_detail_screen.dart';
import 'package:esmorga_flutter/view/events/event_list/view/event_list_screen.dart';
import 'package:esmorga_flutter/view/events/my_events/cubit/my_events_cubit.dart';
import 'package:esmorga_flutter/view/events/my_events/view/my_events_screen.dart';
import 'package:esmorga_flutter/view/home/home_screen.dart';
import 'package:esmorga_flutter/view/login/cubit/login_cubit.dart';
import 'package:esmorga_flutter/view/login/view/login_screen.dart';
import 'package:esmorga_flutter/view/password/recover_password_cubit.dart';
import 'package:esmorga_flutter/view/password/recover_password_screen.dart';
import 'package:esmorga_flutter/view/password/reset_password_cubit.dart';
import 'package:esmorga_flutter/view/password/reset_password_screen.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_cubit.dart';
import 'package:esmorga_flutter/view/profile/view/profile_screen.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/registration_confirmation_cubit.dart';
import 'package:esmorga_flutter/view/registration/view/register_screen.dart';
import 'package:esmorga_flutter/view/registration/view/registration_confirmation_screen.dart';
import 'package:esmorga_flutter/view/welcome/welcome_cubit.dart';
import 'package:esmorga_flutter/view/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String registrationConfirmation = '/registration-confirmation';
  static const String eventList = '/events';
  static const String myEvents = '/my-events';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  static const String recoverPassword = '/recover-password';
  static const String resetPassword = '/reset-password';
  static const String eventDetail = '/event';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: welcome,
      routes: [
        GoRoute(
          path: welcome,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => getIt<WelcomeCubit>(),
              child: WelcomeScreen(
                onLoginRegisterClicked: () {
                  context.push(login);
                },
                onEnterAsGuestClicked: () {
                  context.go(eventList);
                },
              ),
            );
          },
        ),
        GoRoute(
          path: login,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => getIt<LoginCubit>(param1: context, param2: state.uri.queryParameters['message']),
              child: Builder(
                builder: (context) => LoginScreen(
                  snackbarMessage: state.uri.queryParameters['message'],
                  onRegisterClicked: () {
                    context.push(registration);
                  },
                  onForgotPasswordClicked: () {
                    context.push(recoverPassword);
                  },
                  onLoginSuccess: () {
                    context.go(eventList);
                  },
                  onLoginError: () {},
                  onBackClicked: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(welcome);
                    }
                  },
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: registration,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => getIt<RegisterCubit>(param1: context),
              child: const RegisterScreen(),
            );
          },
        ),
        GoRoute(
          path: registrationConfirmation,
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return BlocProvider(
              create: (context) => getIt<RegistrationConfirmationCubit>(),
              child: Builder(
                builder: (context) => RegistrationConfirmationScreen(
                  email: email,
                  onBackClicked: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(welcome);
                    }
                  },
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: changePassword,
          builder: (context, state) => BlocProvider(create: (context) => getIt<ChangePasswordCubit>(param1: context), child: const ChangePasswordScreen()),
        ),
        GoRoute(
          path: recoverPassword,
          builder: (context, state) => BlocProvider(create: (context) => getIt<RecoverPasswordCubit>(param1: context), child: const RecoverPasswordScreen()),
        ),
        GoRoute(
          path: resetPassword,
          builder: (context, state) {
            final code = state.uri.queryParameters['code'];
            return BlocProvider(create: (context) => getIt<ResetPasswordCubit>(param1: context, param2: code), child: ResetPasswordScreen(code: code));
          },
        ),
        GoRoute(
          path: '$eventDetail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return BlocProvider(
              create: (context) => getIt<EventDetailCubit>(param1: context, param2: id),
              child: EventDetailScreen(eventId: id),
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) => HomeScreen(child: child),
          routes: [
            GoRoute(
              path: eventList,
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<EventListCubit>(),
                child: const EventListScreen(),
              ),
            ),
            GoRoute(
              path: myEvents,
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<MyEventsCubit>(),
                child: const MyEventsScreen(),
              ),
            ),
            GoRoute(
              path: profile,
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<ProfileCubit>(),
                child: ProfileScreen(
                  onNavigateToLogin: () {
                    context.go(login);
                  },
                  onNavigateToChangePassword: () {
                    context.push(changePassword);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
