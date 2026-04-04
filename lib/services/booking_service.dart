import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base42_events_mobile/consts/api.dart';
import 'package:http/http.dart' as http;

class BookingRequestPayload {
  final String organizerEntity;
  final String initiatorName;
  final String email;
  final String phone;
  final String companyName;
  final String eventType;
  final String eventName;
  final String eventTheme;
  final String eventPurpose;
  final String eventAgenda;
  final String eventDate;
  final String eventStartTime;
  final String eventEndTime;
  final String physicalPresence;
  final String expectedGuests;

  const BookingRequestPayload({
    required this.organizerEntity,
    required this.initiatorName,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.eventType,
    required this.eventName,
    required this.eventTheme,
    required this.eventPurpose,
    required this.eventAgenda,
    required this.eventDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.physicalPresence,
    required this.expectedGuests,
  });

  Map<String, dynamic> toStrapiData() => {
    'company-name': companyName,
    'email': email,
    'event-agenda': eventAgenda,
    'event-date': eventDate,
    'event-end-time': eventEndTime,
    'event-name': eventName,
    'event-purpose': eventPurpose,
    'event-start-time': eventStartTime,
    'event-theme': eventTheme,
    'event-type': eventType,
    'expected-guests': int.tryParse(expectedGuests.trim()) ?? 0,
    'initiator-name': initiatorName,
    'organizer-entity': organizerEntity,
    'phone': phone,
    'physical-presence': physicalPresence.trim().toLowerCase(),
  };
}

class BookingService {
  static const String _submitUrl = bookingSubmitApiUrl;

  void _logRequest(Map<String, dynamic> payload) {
    print('--- BookingService Request ---');
    print('POST $_submitUrl');
    print('Headers: Content-Type=application/json, Accept=application/json');
    print('Payload: ${jsonEncode(payload)}');
    print('------------------------------');
  }

  void _logResponse(http.Response response) {
    print('--- BookingService Response ---');
    print('Status: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body (raw): ${response.body}');

    try {
      final decoded = jsonDecode(response.body);
      print('Body (decoded JSON): $decoded');
    } catch (_) {
      // Keep raw body when response is not JSON.
    }

    print('-------------------------------');
  }

  Future<http.Response?> submitBookingRequest(
    BookingRequestPayload payload, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final strapiData = payload.toStrapiData();
    // Strapi v4 expects only the 'data' wrapper - don't spread legacy fields at root
    final body = {'data': strapiData};

    _logRequest(body);

    try {
      final response = await http
          .post(
            Uri.parse(_submitUrl),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);

      _logResponse(response);

      if (response.statusCode == 403) {
        print(
          'CRITICAL: 403 Forbidden received. The server is rejecting the request based on identity or source.',
        );
      } else if (response.statusCode == 500) {
        print('500 Internal Server Error response body:');
        print(response.body);
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success: Data written to CMS.');
      } else {
        print('Request finished with status ${response.statusCode}.');
        print('Response body: ${response.body}');
      }

      return response;
    } on TimeoutException catch (e) {
      print('Network timeout while calling BookingService: $e');
      print('Request payload at timeout: ${jsonEncode(body)}');
      return null;
    } on SocketException catch (e) {
      print('Network/DNS error while calling BookingService: $e');
      print('Request payload at network error: ${jsonEncode(body)}');
      return null;
    } catch (e) {
      print('Unexpected error while calling BookingService: $e');
      print('Request payload at unexpected error: ${jsonEncode(body)}');
      return null;
    }
  }
}
