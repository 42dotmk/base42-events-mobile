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

  Future<Event> fetchEventById(int id) async {
    try {
      final url = '$baseUrl/api/events/$id?populate=*';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>;
        return Event.fromJson(data);
      } else {
        debugPrint('Failed to fetch event $id: ${response.statusCode}');
        throw Exception('Failed to load event: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching event by id: $e');
      throw Exception('Error fetching event: $e');
    }
  }

  Future<Event> fetchEventByDocumentId(String documentId) async {
    try {
      final url =
          '$baseUrl/api/events?filters[documentId][\$eq]=$documentId&populate=*';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as List;
        if (data.isEmpty) {
          throw Exception('Event not found for documentId $documentId');
        }
        return Event.fromJson(data.first as Map<String, dynamic>);
      } else {
        debugPrint(
          'Failed to fetch event by documentId $documentId: ${response.statusCode}',
        );
        throw Exception('Failed to load event: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching event by documentId: $e');
      throw Exception('Error fetching event: $e');
    }
  }

  Future<Event> fetchEventByIdentifier(String identifier) async {
    try {
      final parsedId = int.tryParse(identifier);
      if (parsedId != null) {
        return await fetchEventById(parsedId);
      }

      return await fetchEventByDocumentId(identifier);
    } catch (e) {
      debugPrint('Failed to fetch event by identifier $identifier: $e');
      rethrow;
    }
  }
}
