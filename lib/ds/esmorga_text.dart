
import 'package:flutter/material.dart';

class EsmorgaText extends StatelessWidget {
  final String text;
  final EsmorgaTextStyle style;
  final TextAlign textAlign;

  EsmorgaText({
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getTextStyle(context, style),
      textAlign: textAlign,
    );
  }

  TextStyle getTextStyle(BuildContext context, EsmorgaTextStyle style) {
    switch (style) {
      case EsmorgaTextStyle.title:
        return Theme.of(context).textTheme.titleLarge!;
      case EsmorgaTextStyle.h1:
        return Theme.of(context).textTheme.headlineLarge!;
      case EsmorgaTextStyle.h2:
        return Theme.of(context).textTheme.headlineMedium!;
      case EsmorgaTextStyle.body1:
        return Theme.of(context).textTheme.bodyMedium!;
      case EsmorgaTextStyle.bodyAccent:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
      case EsmorgaTextStyle.caption:
        return Theme.of(context).textTheme.labelSmall!;
      case EsmorgaTextStyle.button:
        return Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary);
      default:
        return Theme.of(context).textTheme.bodyMedium!;
    }
  }
}

enum EsmorgaTextStyle {
  title,
  h1,
  h2,
  body1,
  bodyAccent,
  caption,
  button
}
