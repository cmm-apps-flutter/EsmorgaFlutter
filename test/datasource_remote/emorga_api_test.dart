import 'dart:convert';

import 'package:esmorga_flutter/datasource_remote/api/esmorga_guest_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

void main() {
  late Client httpClient;
  late Response response;
  late EsmorgaGuestApi esmorgaApi;

  setUpAll(() {
    // Needed for mocktail `any<Uri>()` matcher
    registerFallbackValue(Uri.parse('https://fallback.local'));
  });

  setUp(() async {
    httpClient = MockHttpClient();
    response = MockResponse();
    esmorgaApi = EsmorgaGuestApi(httpClient);
    when(() => httpClient.get(any())).thenAnswer(
          (_) async => response,
    );
  });

  test('Fetches all events successfully', () async {
    when(() => response.statusCode).thenReturn(200);
    //TODO get from json file
    when(() => response.body).thenReturn(
      jsonEncode({
        "totalEvents": 5,
        "events": [
          {
            "eventId": "66ffd9624bd73c0dbe7e2d6d",
            "eventName": "lololo",
            "eventDate": "2025-03-08T10:05:30.915Z",
            "description": "Join us for an unforgettable celebration as we dance into the apocalypse.",
            "eventType": "Party",
            "imageUrl": "image.url",
            "location": {"lat": 43.35525182148881, "long": -8.41937931298951, "name": "A Coruña"},
            "tags": ["DANCE", "MUSIC"]
          },
          {
            "eventId": "66ffd9734bd73c0dbe7e2d74",
            "eventName": "lololo",
            "eventDate": "2025-03-08T10:05:30.915Z",
            "description": "Join us for an unforgettable celebration as we dance into the apocalypse.",
            "eventType": "Party",
            "imageUrl": "image.url",
            "location": {"lat": 43.35525182148881, "long": -8.41937931298951, "name": "A Coruña"},
            "tags": ["DANCE", "MUSIC"]
          },
          {
            "eventId": "66ffd97b4bd73c0dbe7e2d7b",
            "eventName": "lololo",
            "eventDate": "2025-03-08T10:05:30.915Z",
            "description": "Join us for an unforgettable celebration as we dance into the apocalypse.",
            "eventType": "Party",
            "imageUrl": "image.url",
            "location": {"lat": 43.35525182148881, "long": -8.41937931298951, "name": "A Coruña"},
            "tags": ["DANCE", "MUSIC"]
          },
          {
            "eventId": "66ffd9844bd73c0dbe7e2d82",
            "eventName": "lololo",
            "eventDate": "2025-03-08T10:05:30.915Z",
            "description": "Join us for an unforgettable celebration as we dance into the apocalypse.",
            "eventType": "Party",
            "imageUrl": "image.url",
            "location": {"lat": 43.35525182148881, "long": -8.41937931298951, "name": "A Coruña"},
            "tags": ["DANCE", "MUSIC"]
          },
          {
            "eventId": "66ffda254bd73c0dbe7e2d89",
            "eventName": "lololo",
            "eventDate": "2025-03-08T10:05:30.915Z",
            "description": "Join us for an unforgettable celebration as we dance into the apocalypse.",
            "eventType": "Party",
            "imageUrl": "image.url",
            "location": {"lat": 43.35525182148881, "long": -8.41937931298951, "name": "A Coruña"},
            "tags": ["DANCE", "MUSIC"]
          },
        ]
      }),
    );
    final events = await esmorgaApi.getEvents();
    expect(events.length, 5);
  });

  test('Throws an exception when the response is not 200', () async {
    when(() => response.statusCode).thenReturn(500);
    expect(() async => await esmorgaApi.getEvents(), throwsException);
  });
}
