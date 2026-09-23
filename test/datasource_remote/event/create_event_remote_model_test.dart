import 'package:esmorga_flutter/datasource_remote/event/create_event_remote_model.dart';
import 'package:esmorga_flutter/domain/event/model/create_event_params.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes an empty description as null', () {
    final model = CreateEventRemoteModel.fromParams(const CreateEventParams(
      eventName: 'Event',
      eventDate: '2030-06-15T18:30:00.000Z',
      description: null,
      eventType: EventType.party,
      locationName: 'Barcelona',
    ));

    expect(model.toJson()['description'], isNull);
  });

  test('serializes a non-empty description unchanged', () {
    const description = 'A valid event description';
    final model = CreateEventRemoteModel.fromParams(const CreateEventParams(
      eventName: 'Event',
      eventDate: '2030-06-15T18:30:00.000Z',
      description: description,
      eventType: EventType.party,
      locationName: 'Barcelona',
    ));

    expect(model.toJson()['description'], description);
  });
}
