import 'package:base42_events_mobile/types.dart';
import 'package:flutter/material.dart';

class MyBookingsProvider extends ChangeNotifier {
  final List<MyBooking> _bookings = [];

  List<MyBooking> get bookings => List.unmodifiable(_bookings);

  List<MyBooking> get upcomingBookings {
    final now = DateTime.now();
    final items =
        _bookings.where((booking) => booking.endDateTime.isAfter(now)).toList()
          ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    return List.unmodifiable(items);
  }

  List<MyBooking> get pastBookings {
    final now = DateTime.now();
    final items =
        _bookings.where((booking) => !booking.endDateTime.isAfter(now)).toList()
          ..sort((a, b) => b.startDateTime.compareTo(a.startDateTime));
    return List.unmodifiable(items);
  }

  void addFromRequest(BookingRequestPayload payload) {
    _bookings.add(MyBooking.fromBookingRequest(payload));
    notifyListeners();
  }
}
