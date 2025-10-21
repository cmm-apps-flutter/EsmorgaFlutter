import 'dart:ui' as ui;

import 'package:esmorga_flutter/datasource_remote/config/environment_config.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.initFromDartDefine();
  final ui.Locale deviceLocale = ui.PlatformDispatcher.instance.locale;
  await setupDi(deviceLocale);
  runApp(const EsmorgaApp());
}

class EsmorgaApp extends StatelessWidget {
  const EsmorgaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();
    return MaterialApp.router(
      title: 'Esmorga',
      theme: getThemeData(context),
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
    );
  }
}
