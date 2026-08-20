import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccentForeground', () {
    test('black text on yellow accents', () {
      const yellow = Color(0xFFFAE127);
      expect(yellow.readableForeground(), Colors.black);
    });

    test('white text on teal accents', () {
      const teal = Color(0xFF009EA1);
      expect(teal.readableForeground(), Colors.white);
    });
  });

  group('BookingRequestPayload', () {
    const payload = BookingRequestPayload(
      organizerEntity: 'Base42',
      initiatorName: '',
      email: 'test@42.mk',
      phone: '',
      companyName: '',
      eventType: 'Studio',
      room: 'studio',
      eventName: '',
      eventTheme: '',
      eventPurpose: '',
      eventAgenda: 'Recording session',
      eventDate: '2026-08-20',
      eventStartTime: '09:00',
      eventEndTime: '13:00',
      physicalPresence: '',
      expectedGuests: '5',
    );

    test('toStrapiData includes room', () {
      expect(payload.toStrapiData()['room'], 'studio');
    });

    test('toStrapiData omits empty room', () {
      final data = BookingRequestPayload(
        organizerEntity: 'Base42',
        initiatorName: '',
        email: 'test@42.mk',
        phone: '',
        companyName: '',
        eventType: 'Studio',
        eventName: '',
        eventTheme: '',
        eventPurpose: '',
        eventAgenda: '',
        eventDate: '2026-08-20',
        eventStartTime: '09:00',
        eventEndTime: '13:00',
        physicalPresence: '',
        expectedGuests: '5',
      ).toStrapiData();

      expect(data.containsKey('room'), isFalse);
    });

    test('MyBooking carries room from payload', () {
      final booking = MyBooking.fromBookingRequest(payload);
      expect(booking.room, 'studio');
      expect(booking.eventType, 'Studio');
      expect(booking.startDateTime, DateTime(2026, 8, 20, 9, 0));
      expect(booking.endDateTime, DateTime(2026, 8, 20, 13, 0));
    });
  });
}
