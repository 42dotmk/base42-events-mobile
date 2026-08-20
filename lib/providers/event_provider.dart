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
    final cached = await _eventService.getCachedEvents();

    if (cached != null && cached.isNotEmpty) {
      _events = cached;
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    await _refreshFromNetwork();
  }

  Future<void> refreshEvents() async {
    await _refreshFromNetwork();
  }

  Future<void> _refreshFromNetwork() async {
    try {
      _events = await _eventService.fetchEvents();
      _errorMessage = null;
    } catch (e) {
      debugPrint('EventProvider: Failed to load events: $e');
      if (_events.isEmpty) {
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
