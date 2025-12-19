import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/view/change_password/view/change_password_screen.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_cubit.dart';
import 'package:esmorga_flutter/view/events/event_attendees/view/event_attendees_screen.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/view/event_detail_screen.dart';
import 'package:esmorga_flutter/view/home_tab/view/home_tab_screen.dart';
import 'package:esmorga_flutter/view/events/my_events/view/my_events_screen.dart';
import 'package:esmorga_flutter/view/home/home_screen.dart';
import 'package:esmorga_flutter/view/login/view/login_screen.dart';
import 'package:esmorga_flutter/view/password/recover_password_screen.dart';
import 'package:esmorga_flutter/view/password/reset_password_screen.dart';
import 'package:esmorga_flutter/view/poll_detail/view/poll_detail_screen.dart';
import 'package:esmorga_flutter/view/profile/view/profile_screen.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_cubit.dart';
import 'package:esmorga_flutter/view/registration/verify_account/view/verify_account_screen.dart';
import 'package:esmorga_flutter/view/registration/view/register_screen.dart';
import 'package:esmorga_flutter/view/registration/view/registration_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:esmorga_flutter/view/splash/view/splash_screen.dart';
import 'package:esmorga_flutter/view/splash/cubit/splash_cubit.dart';

class AppRoutes {
  static const String splash = '/onboarding/splash';
  static const String login = '/auth/login';
  static const String registration = '/auth/registration';
  static const String registrationConfirmation = '/auth/registration-confirmation';
  static const String eventList = '/home/events';
  static const String myEvents = '/home/my-events';
  static const String profile = '/home/profile';
  static const String changePassword = '/auth/change-password';
  static const String recoverPassword = '/auth/recover-password';
  static const String resetPassword = '/auth/reset-password';
  static const String eventDetail = '/feature/event';
  static const String pollDetail = '/feature/poll';
  static const String verifyAccount = '/auth/verify-account';
  static const String eventAttendees = '/feature/event_attendees/:eventId';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      routes: [
        ...onboardingRoutes,
        ...authRoutes,
        ...featureRoutes,
        ...mainRoutes,
      ],
    );
  }

  static final List<RouteBase> onboardingRoutes = [
    GoRoute(
      path: splash,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<SplashCubit>(),
        child: SplashScreen(onFinished: () => context.go(eventList)),
      ),
    ),
  ];

  static final List<RouteBase> authRoutes = [
    GoRoute(
      path: login,
      builder: (context, state) => LoginScreen(
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
          context.pop();
        },
      ),
    ),
    GoRoute(
      path: registration,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: registrationConfirmation,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return RegistrationConfirmationScreen(
          email: email,
          onBackClicked: () {
            context.pop();
          },
        );
      },
    ),
    GoRoute(
      path: changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: recoverPassword,
      builder: (context, state) => const RecoverPasswordScreen(),
    ),
    GoRoute(
      path: resetPassword,
      builder: (context, state) {
        final code = state.uri.queryParameters['code'];
        return ResetPasswordScreen(code: code);
      },
    ),
    GoRoute(
      path: verifyAccount,
      builder: (context, state) {
        final code = state.uri.queryParameters['code'] ?? '';
        return BlocProvider(
          create: (ctx) => getIt<VerifyAccountCubit>(param1: ctx, param2: code),
          child: VerifyAccountScreen(
            onAccountVerified: () {
              context.go(eventList);
            },
          ),
        );
      },
    ),
  ];

  static final List<RouteBase> featureRoutes = [
    GoRoute(
      path: eventDetail,
      builder: (context, state) {
        final event = state.extra as Event;
        return BlocProvider(
            create: (context) => getIt<EventDetailCubit>(param1: context, param2: event),
            child: EventDetailScreen(
              goToLogin: () => context.push(login),
              goToAttendees: (eventId) => context.push('/event_attendees/$eventId'),
            ));
      },
    ),
    GoRoute(
      path: pollDetail,
      builder: (context, state) {
        final poll = state.extra as Poll;
        return PollDetailScreen(poll: poll);
      },
    ),
    GoRoute(
      path: eventAttendees,
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;

        return BlocProvider(
          create: (_) => getIt<EventAttendeesCubit>(param1: eventId),
          child: EventAttendeesScreen(
            eventId: eventId,
          ),
        );
      },
    ),
  ];

  static final List<RouteBase> mainRoutes = [
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          path: eventList,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: HomeTabScreen(
              onDetailsClicked: (event) async {
                await context.push(AppRoutes.eventDetail, extra: event);
              },
              onPollClicked: (poll) async {
                await context.push(AppRoutes.pollDetail, extra: poll);
              },
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: myEvents,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: MyEventsScreen(
              onDetailsClicked: (event) async {
                final didChange = await context.push(AppRoutes.eventDetail, extra: event) as bool?;
                return didChange;
              },
              onSignInClicked: () {
                context.push(login);
              },
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: profile,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: ProfileScreen(
              onNavigateToLogin: () {
                context.push(login);
              },
              onNavigateToChangePassword: () {
                context.push(changePassword);
              },
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],
    ),
  ];
}
