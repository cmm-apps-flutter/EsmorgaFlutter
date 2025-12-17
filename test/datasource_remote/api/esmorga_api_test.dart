import 'dart:convert';

import 'package:esmorga_flutter/datasource_remote/api/esmorga_api.dart';
import 'package:esmorga_flutter/domain/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

void main() {
  late Client httpClient;
  late Response response;
  late EsmorgaApi esmorgaApi;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://fallback.local'));
  });

  setUp(() {
    httpClient = MockHttpClient();
    response = MockResponse();
    esmorgaApi = EsmorgaApi(httpClient);
    when(() => httpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => response);
  });

  group('joinEvent', () {
    test('completes successfully when status code is 204', () async {
      when(() => response.statusCode).thenReturn(204);
      await esmorgaApi.joinEvent('123');
      verify(() => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).called(1);
    });

    test('throws EventFullException when status code is 422', () async {
      when(() => response.statusCode).thenReturn(422);
      expect(
        () => esmorgaApi.joinEvent('123'),
        throwsA(isA<EventFullException>()),
      );
    });

    test('throws EsmorgaException when status code is 500', () async {
      when(() => response.statusCode).thenReturn(500);
      expect(
        () => esmorgaApi.joinEvent('123'),
        throwsA(isA<EsmorgaException>()),
      );
    });
  });
}
