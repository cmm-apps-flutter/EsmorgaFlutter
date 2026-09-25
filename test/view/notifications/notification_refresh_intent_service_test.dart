import 'package:esmorga_flutter/view/notifications/notification_refresh_intent_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buffers a cold-start refresh intent until binding and consumes it once', () async {
    final service = NotificationRefreshIntentService();
    service.add();
    final received = <void>[];
    service.intents.listen(received.add);

    service.bind();
    await Future<void>.delayed(Duration.zero);
    service.bind();

    expect(received, hasLength(1));
    service.dispose();
  });

  test('emits refresh intents after binding', () async {
    final service = NotificationRefreshIntentService();
    final received = <void>[];
    service.intents.listen(received.add);
    service.bind();
    service.add();

    await Future<void>.delayed(Duration.zero);

    expect(received, hasLength(1));
    service.dispose();
  });
}