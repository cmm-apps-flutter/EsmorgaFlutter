import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screenshot_helper.dart';

// We don't need to mock dependencies for HomeScreen as it only depends on GoRouter,
// which we will provide via a real instance with dummy routes.

void main() {
  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildAppWithRoute(String initialLocation) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        ShellRoute(
          builder: (context, state, child) => HomeScreen(child: child),
          routes: [
            GoRoute(
              path: '/events',
              builder: (context, state) =>
                  Container(color: Colors.white, child: const Center(child: Text('Events Content'))),
            ),
            GoRoute(
              path: '/my-events',
              builder: (context, state) =>
                  Container(color: Colors.white, child: const Center(child: Text('My Events Content'))),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) =>
                  Container(color: Colors.white, child: const Center(child: Text('Profile Content'))),
            ),
          ],
        ),
      ],
    );

    // We use Router.withConfig to avoid nesting MaterialApp inside ScreenshotApp's MaterialApp.
    // ScreenshotApp provides the Theme and Localizations.
    return Router.withConfig(config: router);
  }

  screenshotGolden(
    'home_screen_explore',
    theme: lightTheme,
    screenshotPath: 'home_screen',
    buildHome: () => buildAppWithRoute('/events'),
  );

  screenshotGolden(
    'home_screen_my_events',
    theme: lightTheme,
    screenshotPath: 'home_screen',
    buildHome: () => buildAppWithRoute('/my-events'),
  );

  screenshotGolden(
    'home_screen_profile',
    theme: lightTheme,
    screenshotPath: 'home_screen',
    buildHome: () => buildAppWithRoute('/profile'),
  );
}
