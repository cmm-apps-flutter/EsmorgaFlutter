import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/event_bloc.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/event_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupDi();
  runApp(const EsmorgaApp());
}

class EsmorgaApp extends StatelessWidget {
  const EsmorgaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<EventBloc>()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: getThemeData(context),
          home: const EventListScreen(),
        ));
  }
}
