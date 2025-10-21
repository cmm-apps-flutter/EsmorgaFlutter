import 'package:flutter/material.dart';

class EsmorgaLinearLoader extends StatelessWidget {
  const EsmorgaLinearLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.0,
      child: LinearProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

class EsmorgaCircularLoader extends StatelessWidget {
  final double size;

  const EsmorgaCircularLoader({
    super.key,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        strokeWidth: 2.0,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
