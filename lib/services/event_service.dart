import 'dart:convert';
import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/services/cache_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:base42_events_mobile/models/event.dart';

class EventService {
  static const _cacheKey = 'events';

  Future<List<Event>?> getCachedEvents() async {
    final cached = await CacheService.instance.get<List<dynamic>>(_cacheKey);
    if (cached == null) return null;

    try {
      final events = cached
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();
      events.sort((a, b) => b.start.compareTo(a.start));
      return events;
    } catch (e) {
      debugPrint('EventService: discarding invalid cached events: $e');
      return null;
    }
  }

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

        await CacheService.instance.set(_cacheKey, data);

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
      final response = await http.get(Uri.parse('$eventsBaseUrl/$eventId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>;
        return Event.fromJson(data);
      } else {
        debugPrint('Failed to fetch event $eventId: ${response.statusCode}');
        throw Exception('Failed to load event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching event $eventId: $e');
    }
  }

  Future<Event> fetchEventByDocumentId(String documentId) async {
    try {
      final url =
          '$eventsBaseUrl?filters[documentId][\$eq]=$documentId&populate=*';
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
        return await getEventDetails(parsedId);
      }

      return await fetchEventByDocumentId(identifier);
    } catch (e) {
      debugPrint('Failed to fetch event by identifier $identifier: $e');
      rethrow;
    }
  }
}
