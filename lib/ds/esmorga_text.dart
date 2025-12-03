
import 'package:flutter/material.dart';

class EsmorgaText extends StatelessWidget {
  final String text;
  final EsmorgaTextStyle style;
  final TextAlign textAlign;
  final int maxLines;

  const EsmorgaText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.maxLines = 999999,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getTextStyle(context, style),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getTextStyle(BuildContext context, EsmorgaTextStyle style) {
    switch (style) {
      case EsmorgaTextStyle.title:
        return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          height: 40 / 32,
          letterSpacing: -0.8,
        );
      case EsmorgaTextStyle.heading1:
        return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          height: 27.5 / 22,
          letterSpacing: -0.33,
        );
      case EsmorgaTextStyle.heading2:
        return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          height: 22.5 / 18,
          letterSpacing: -0.27,
        );
      case EsmorgaTextStyle.body1:
        return Theme.of(context).textTheme.bodyMedium!..copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 24 / 16, 
          letterSpacing: 0,
        );
      case EsmorgaTextStyle.body1Accent:
      return Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

      case EsmorgaTextStyle.caption:
        return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          height: 21 / 14,
          letterSpacing: 0,
        );
      case EsmorgaTextStyle.button:
        return Theme.of(context).textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          height: 21 / 14,
          letterSpacing: 0.21,
        );
    }
  }
}

enum EsmorgaTextStyle {
  title,
  heading1,
  heading2,
  body1,
  body1Accent,
  caption,
  button,
}
