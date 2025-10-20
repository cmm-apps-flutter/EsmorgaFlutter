import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EsmorgaFullScreenError extends StatelessWidget {
  final String? animation;
  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback buttonAction;

  const EsmorgaFullScreenError({
    super.key,
    this.animation,
    required this.title,
    this.subtitle,
    required this.buttonText,
    required this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (animation != null)
                      SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Lottie.asset(
                          animation!,
                          key: const Key('error_animation'),
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      const Icon(
                        Icons.cancel_outlined,
                        size: 128.0,
                        key: Key('error_icon'),
                      ),
                    const SizedBox(height: 16.0),
                    EsmorgaText(
                      text: title,
                      style: EsmorgaTextStyle.heading1,
                      textAlign: TextAlign.center,
                      key: const Key('error_screen_title'),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: EsmorgaText(
                          text: subtitle!,
                          style: EsmorgaTextStyle.body1,
                          textAlign: TextAlign.center,
                          key: const Key('error_screen_subtitle'),
                        ),
                      ),
                  ],
                ),
              ),
              EsmorgaButton(
                text: buttonText,
                onClick: buttonAction,
                key: const Key('error_screen_retry_button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorScreenTestTags {
  static const String errorAnimation = 'error_animation';
  static const String errorTitle = 'error_screen_title';
  static const String errorRetryButton = 'error_screen_retry_button';
  static const String errorSubtitle = 'error_screen_subtitle';
}

