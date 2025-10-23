import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoggedOutView extends StatelessWidget {
  final VoidCallback onSignIn;

  const LoggedOutView({required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/oops.json',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                EsmorgaText(
                  text: l10n.unauthenticatedErrorMessage,
                  style: EsmorgaTextStyle.heading2,
                ),
              ],
            ),
          ),
          EsmorgaButton(
            text: l10n.buttonLogin,
            onClick: onSignIn,
          ),
        ],
      ),
    );
  }
}
