import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventRemoteModel', () {
    test('fromJson accepts missing description', () {
      final event = EventRemoteModel.fromJson({
        'eventId': 'event-1',
        'eventName': 'Optional description event',
        'eventDate': '2026-09-23T20:00:00.000Z',
        'eventType': 'party',
        'location': {'name': 'A Coruna'},
        'currentAttendeeCount': 0,
        'joinDeadline': '2026-09-22T20:00:00.000Z',
      });

      expect(event.remoteDescription, isNull);
    });
  });
}
