import 'dart:convert';
import 'package:base42_events_mobile/consts/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:base42_events_mobile/models/event.dart';

class EventService {
  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(eventsApiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as List;

        final events = data
            .map(
              (eventJson) => Event.fromJson(eventJson as Map<String, dynamic>),
            )
            .toList();

        events.sort((a, b) => b.start.compareTo(a.start));

        return events;
      } else {
        debugPrint('Failed to fetch events: ${response.statusCode}');
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }

  Future<Event> getEventDetails(int eventId) async {
    try {
      final response = await http.get(Uri.parse('$eventsApiUrl/$eventId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>;

        return Event.fromJson(data);
      } else {
        throw Exception('Failed to load event details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching event details: $e');
    }
  }
}
