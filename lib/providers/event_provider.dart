import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/services/event_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  EventProvider() {
    loadEvents();
  }

  Event? getEventById(int eventId) {
    try {
      return _events.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  List<Event> getEventsByIds(List<int> eventIds) {
    return eventIds
        .map((id) => getEventById(id))
        .where((event) => event != null)
        .cast<Event>()
        .toList();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _events = await _eventService.fetchEvents();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('EventProvider: Failed to load events: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}
