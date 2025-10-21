import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/welcome/model/welcome_ui_model.dart';
import 'package:esmorga_flutter/view/welcome/welcome_cubit.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onLoginRegisterClicked;
  final VoidCallback onEnterAsGuestClicked;

  const WelcomeScreen({
    super.key,
    required this.onLoginRegisterClicked,
    required this.onEnterAsGuestClicked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<WelcomeCubit>(),
      child: _WelcomeForm(
        onLoginRegisterClicked: onLoginRegisterClicked,
        onEnterAsGuestClicked: onEnterAsGuestClicked,
      ),
    );
  }
}

class _WelcomeForm extends StatefulWidget {
  final VoidCallback onLoginRegisterClicked;
  final VoidCallback onEnterAsGuestClicked;

  const _WelcomeForm({
    required this.onLoginRegisterClicked,
    required this.onEnterAsGuestClicked,
  });

  @override
  State<_WelcomeForm> createState() => _WelcomeFormState();
}

class _WelcomeFormState extends State<_WelcomeForm> {
  @override
  void initState() {
    super.initState();

    // Listen to effects
    context.read<WelcomeCubit>().effects.listen((effect) {
      if (effect is NavigateToEventList) {
        widget.onEnterAsGuestClicked();
      } else if (effect is NavigateToLogin) {
        widget.onLoginRegisterClicked();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<WelcomeCubit, WelcomeUiState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo
                  FractionallySizedBox(
                    widthFactor: 0.3,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: Image.asset(
                          'assets/images/esmorga_logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: Icon(
                                Icons.event_outlined,
                                size: 64.0,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  EsmorgaButton(
                    text: localizations.buttonLoginRegister,
                    onClick: () {
                      context.read<WelcomeCubit>().onPrimaryButtonClicked();
                    },
                    key: const Key('welcome_screen_primary_button'),
                  ),
                  const SizedBox(height: 32.0),
                  EsmorgaButton(
                    text: localizations.buttonGuest,
                    primary: false,
                    onClick: () {
                      context.read<WelcomeCubit>().onSecondaryButtonClicked();
                    },
                    key: const Key('welcome_screen_secondary_button'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
