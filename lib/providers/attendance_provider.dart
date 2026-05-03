import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/models/user_event.dart';
import 'package:base42_events_mobile/providers/event_provider.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  final EventProvider? _eventProvider;
  final UserService _userService = UserService();
  final Map<int, UserEventWithDetails> _userEvents = {};

  AttendanceProvider({EventProvider? eventProvider})
    : _eventProvider = eventProvider;

  String? getStatus(int eventId) => _userEvents[eventId]?.status;

  List<MapEntry<Event, String>> get attendanceEntries => _userEvents.entries
      .map((e) => MapEntry(e.value.event, e.value.status))
      .where((entry) => entry.value.isNotEmpty)
      .toList();

  Future<void> updateEventAttendanceStatus({
    required String token,
    required int userId,
    required Event event,
    required EventAttendanceStatus status,
  }) async {
    final statusString = status.name;
    await _userService.changeAttendanceStatus(
      token: token,
      eventId: event.id,
      userId: userId,
      status: statusString,
    );

    _userEvents[event.id] = UserEventWithDetails(
      event: event,
      status: status.name,
    );
    notifyListeners();
    try {
      await loadUserEvents(token, userId);
    } catch (e) {
      debugPrint('Failed to reload user events after status update: $e');
    }
  }

  Future<void> cancelAttendance({
    required String token,
    required int userId,
    required int eventId,
  }) async {
    await _userService.changeAttendanceStatus(
      token: token,
      eventId: eventId,
      userId: userId,
      status: 'cancelled',
    );

    _userEvents.remove(eventId);
    notifyListeners();
    try {
      await loadUserEvents(token, userId);
    } catch (e) {
      debugPrint('Failed to reload user events after cancellation: $e');
    }
  }

  void removeStatus(int eventId) {
    _userEvents.remove(eventId);
    notifyListeners();
  }

  void clearAll() {
    _userEvents.clear();
    notifyListeners();
  }

  Future<void> loadUserEvents(String token, int userId) async {
    try {
      List<UserEventResponse> userEvents = await _userService
          .getUserEventsWithDetails(token, userId);
      final events = _eventProvider?.events ?? const [];

      _userEvents.clear();
      for (var userEvent in userEvents) {
        Event? event;
        try {
          event = events.firstWhere((e) => e.id == userEvent.eventId);
        } catch (_) {
          debugPrint('AttendanceProvider: event ${userEvent.eventId} not found in local list, skipping');
          continue;
        }

        _userEvents[userEvent.eventId] = UserEventWithDetails(
          event: event,
          status: userEvent.status,
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user events: $e');
    }
  }
}
