import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

void screenshotGolden(
  String description, {
  required ThemeData theme,
  required Widget Function() buildHome,
  Future<void> Function(WidgetTester tester)? beforeScreenshot,
  Future<void> Function(WidgetTester tester)? afterBuild,
  String? screenshotPath,
  double allowedDiffPercent = 0.02,
}) {
  final devices = [GoldenScreenshotDevices.androidPhone.device, GoldenScreenshotDevices.iphone.device];
  testGoldens(description, (tester) async {
    for (final device in devices) {
      await beforeScreenshot?.call(tester);

      final widget = ScreenshotApp(theme: theme, device: device, home: buildHome());

      await mockNetworkImages(() async {
        await tester.pumpWidget(widget);

        await afterBuild?.call(tester);

        await tester.loadAssets();
        await tester.pumpFrames(tester.widget(find.byType(ScreenshotApp)), const Duration(seconds: 1));

        final path = screenshotPath != null
            ? '$screenshotPath/${description}_${device.platform.name}'
            : '${description}_${device.platform.name}';

        await tester.expectScreenshot(device, path);
      });
    }
  }, allowedDiffPercent: allowedDiffPercent);
}
