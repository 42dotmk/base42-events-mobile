import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/types.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static const String _submitUrl = bookingSubmitApiUrl;
  Future<http.Response?> submitBookingRequest(
    BookingRequestPayload payload, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final strapiData = payload.toStrapiData();
    final body = {'data': strapiData};
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

      return response;
    } on TimeoutException {
      return null;
    } on SocketException {
      return null;
    } catch (_) {
      return null;
    }
  }
}
