
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
        return Theme.of(context).textTheme.titleLarge!;
      case EsmorgaTextStyle.heading1:
        return Theme.of(context).textTheme.headlineLarge!;
      case EsmorgaTextStyle.heading2:
        return Theme.of(context).textTheme.headlineMedium!;
      case EsmorgaTextStyle.body1:
        return Theme.of(context).textTheme.bodyMedium!;
      case EsmorgaTextStyle.body1Accent:
        return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
      case EsmorgaTextStyle.caption:
        return Theme.of(context).textTheme.labelSmall!;
      case EsmorgaTextStyle.button:
        return Theme.of(context).textTheme.labelLarge!;
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
