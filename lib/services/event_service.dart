import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:base42_events_mobile/models/event.dart';

class EventService {
  static const String baseUrl = 'https://cms.42.mk';
  static const String apiUrl = '$baseUrl/api/events?populate=*';

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

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
}
