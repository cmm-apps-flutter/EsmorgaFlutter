import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  LoggingHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (kDebugMode) {
      _logRequest(request);
    }

    final response = await _inner.send(request);

    if (kDebugMode) {
      return await _logResponse(response);
    }

    return response;
  }

  void _logRequest(http.BaseRequest request) {
    _logger.d('📤 REQUEST: ${request.method} ${request.url}');

    if (request.headers.isNotEmpty) {
      _logger.d('Headers: ${request.headers}');
    }

    if (request is http.Request && request.body.isNotEmpty) {
      try {
        final prettyJson = _prettyPrintJson(request.body);
        _logger.d('Body: $prettyJson');
      } catch (e) {
        _logger.d('Body: ${request.body}');
      }
    }
  }

  Future<http.StreamedResponse> _logResponse(http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();

    _logger.i('📥 RESPONSE: ${response.request?.method} ${response.request?.url}');
    _logger.i('Status Code: ${response.statusCode} ${response.reasonPhrase ?? ""}');

    if (response.headers.isNotEmpty) {
      _logger.i('Headers: ${response.headers}');
    }

    if (responseBody.isNotEmpty) {
      try {
        final prettyJson = _prettyPrintJson(responseBody);
        _logger.i('Response Body: $prettyJson');
      } catch (e) {
        _logger.i('Response Body: $responseBody');
      }
    } else {
      _logger.i('Response Body: (empty)');
    }

    // Return a new StreamedResponse with the body we read
    return http.StreamedResponse(
      http.ByteStream.fromBytes(utf8.encode(responseBody)),
      response.statusCode,
      contentLength: responseBody.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  String _prettyPrintJson(String jsonString) {
    try {
      final object = json.decode(jsonString);
      final encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(object);
    } catch (e) {
      return jsonString;
    }
  }
}

