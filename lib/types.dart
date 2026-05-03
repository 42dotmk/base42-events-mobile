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

enum MyBookingStatus { pending, confirmed, completed, cancelled }

class MyBooking {
  final String organizerEntity;
  final String eventName;
  final String eventType;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final MyBookingStatus status;

  const MyBooking({
    required this.organizerEntity,
    required this.eventName,
    required this.eventType,
    required this.startDateTime,
    required this.endDateTime,
    this.status = MyBookingStatus.pending,
  });

  String get statusLabel {
    switch (status) {
      case MyBookingStatus.pending:
        return 'Pending';
      case MyBookingStatus.confirmed:
        return 'Confirmed';
      case MyBookingStatus.completed:
        return 'Completed';
      case MyBookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  factory MyBooking.fromBookingRequest(BookingRequestPayload payload) {
    final date = _parseDate(payload.eventDate);
    final start = _parseTime(payload.eventStartTime);
    final end = _parseTime(payload.eventEndTime);

    return MyBooking(
      organizerEntity: payload.organizerEntity,
      eventName: payload.eventName,
      eventType: payload.eventType,
      startDateTime: DateTime(
        date.year,
        date.month,
        date.day,
        start.$1,
        start.$2,
      ),
      endDateTime: DateTime(date.year, date.month, date.day, end.$1, end.$2),
    );
  }

  static DateTime _parseDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return DateTime.now();
    }

    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  static (int, int) _parseTime(String value) {
    final segments = value.split(':');
    if (segments.length < 2) {
      return (0, 0);
    }

    final hour = int.tryParse(segments[0]) ?? 0;
    final minute = int.tryParse(segments[1]) ?? 0;
    return (hour, minute);
  }
}
