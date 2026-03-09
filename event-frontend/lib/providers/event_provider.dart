// This provider manages event lists, event details,
// and the list of registrations for the logged in user.

import 'package:flutter/material.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService = EventService();

  List<dynamic> _events = [];
  List<dynamic> _myRegistrations = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get events => _events;
  List<dynamic> get myRegistrations => _myRegistrations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Loads all events from the backend.
  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _events = await _eventService.fetchEvents();
    } catch (e) {
      _error = 'Failed to load events';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refreshes the "My Registrations" list.
  Future<void> loadMyRegistrations() async {
    try {
      _myRegistrations = await _eventService.fetchMyRegistrations();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load registrations';
      notifyListeners();
    }
  }
}

