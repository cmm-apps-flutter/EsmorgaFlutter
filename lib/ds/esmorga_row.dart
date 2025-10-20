import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:flutter/material.dart';

class EsmorgaRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? caption;
  final VoidCallback onClick;

  const EsmorgaRow({
    super.key,
    required this.title,
    this.subtitle,
    this.caption,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EsmorgaText(
                    text: title,
                    style: EsmorgaTextStyle.heading2,
                    maxLines: 1,
                  ),
                  if (subtitle != null)
                    EsmorgaText(
                      text: subtitle!,
                      style: EsmorgaTextStyle.body1,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (caption != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 74.0),
                      child: EsmorgaText(
                        text: caption!,
                        style: EsmorgaTextStyle.caption,
                        maxLines: 1,
                      ),
                    ),
                  ),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

