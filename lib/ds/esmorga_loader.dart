import 'package:flutter/material.dart';

class EsmorgaLinearLoader extends StatelessWidget {
  final double height;

  const EsmorgaLinearLoader({
    super.key,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: height,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

class EsmorgaCircularLoader extends StatelessWidget {
  final double size;

  const EsmorgaCircularLoader({
    Key? key,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        strokeWidth: 2.0,
      ),
    );
  }
}
