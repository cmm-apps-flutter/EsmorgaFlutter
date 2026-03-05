import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaSnackbar extends SnackBar {
  EsmorgaSnackbar(String message, {super.key})
      : super(
          content: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final snackbarTextColor = theme.colorScheme.onInverseSurface;
              return Theme(
                data: theme.copyWith(
                  textTheme: theme.textTheme.apply(
                        bodyColor: snackbarTextColor,
                        displayColor: snackbarTextColor,
                      ),
                ),
                child: EsmorgaText(
                  text: message,
                  style: EsmorgaTextStyle.body1,
                ),
              );
            },
          ),
        );
}
