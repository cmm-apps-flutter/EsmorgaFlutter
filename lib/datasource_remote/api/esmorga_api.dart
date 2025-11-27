import 'dart:convert';

import 'package:esmorga_flutter/datasource_remote/config/environment_config.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_attendees_remote_model.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';
import 'package:http/http.dart' as http;

class EsmorgaApi {
  final http.Client authenticatedHttpClient;

  String get baseUrl => EnvironmentConfig.currentBaseUrl;
  String eventsEndpoint = 'account/events';

  EsmorgaApi(this.authenticatedHttpClient);

  Future<List<EventRemoteModel>> getMyEvents() async {
    final result = await authenticatedHttpClient.get(
      Uri.parse('$baseUrl$eventsEndpoint'),
    );
    if (result.statusCode == 200) {
      final eventListWrapper = EventListWrapperRemoteModel.fromJson(json.decode(result.body));
      return eventListWrapper.remoteEventList;
    } else {
      throw Exception('Failed to load my events');
    }
  }

  Future<void> joinEvent(String eventId) async {
    final result = await authenticatedHttpClient.post(
      Uri.parse('$baseUrl$eventsEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'eventId': eventId}),
    );
    if (result.statusCode != 204) {
      throw Exception('Failed to join event');
    }
  }

  Future<void> leaveEvent(String eventId) async {
    final request = http.Request('DELETE', Uri.parse('$baseUrl$eventsEndpoint'));
    request.headers['Content-Type'] = 'application/json';
    request.body = json.encode({'eventId': eventId});

    final streamedResponse = await authenticatedHttpClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 204) {
      throw Exception('Failed to leave event');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final result = await authenticatedHttpClient.put(
      Uri.parse('${baseUrl}account/password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'currentPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    if (result.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }
  Future<List<EventAttendeeRemoteModel>> getEventAttendees(String eventId) async {
    final url = Uri.parse('${baseUrl}events/$eventId/users');
    final result = await authenticatedHttpClient.get(url);

    if (result.statusCode == 200) {
      final jsonData = json.decode(result.body) as Map<String, dynamic>;
      final users = (jsonData['users'] as List)
          .map((e) => EventAttendeeRemoteModel.fromJson({'name': e}))
          .toList();
      return users;
    } else {
      throw Exception('Failed to load event attendees');
    }
  }
}