// This service wraps all event related API calls
// such as listing events, loading event details,
// registering for an event and fetching user registrations.

import 'package:dio/dio.dart';
import 'api_client.dart';

class EventService {
  final Dio _dio = ApiClient.client;

  // Fetches all events visible to users.
  Future<List<dynamic>> fetchEvents() async {
    final response = await _dio.get('/events');
    return response.data as List<dynamic>;
  }

  // Fetches a single event by id.
  Future<Map<String, dynamic>> fetchEventDetail(int eventId) async {
    final response = await _dio.get('/events/$eventId');
    return response.data as Map<String, dynamic>;
  }

  // Registers the current authenticated user for the given event.
  Future<void> registerForEvent({
    required int eventId,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _dio.post('/events/$eventId/register', data: {
      'name': name,
      'email': email,
      'phone': phone,
    });
  }

  // Loads registrations for the currently authenticated user.
  Future<List<dynamic>> fetchMyRegistrations() async {
    final response = await _dio.get('/my/registrations');
    return response.data as List<dynamic>;
  }

  // Admin: fetch all events along with registration counts.
  Future<List<dynamic>> adminFetchEvents() async {
    final response = await _dio.get('/admin/events');
    return response.data as List<dynamic>;
  }

  // Admin: create a new event.
  Future<void> adminCreateEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
  }) async {
    await _dio.post('/admin/events', data: {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
    });
  }

  // Admin: update an event.
  Future<void> adminUpdateEvent({
    required int id,
    required String title,
    required String description,
    required DateTime date,
    required String location,
  }) async {
    await _dio.put('/admin/events/$id', data: {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
    });
  }

  // Admin: delete an event.
  Future<void> adminDeleteEvent(int id) async {
    await _dio.delete('/admin/events/$id');
  }
}

