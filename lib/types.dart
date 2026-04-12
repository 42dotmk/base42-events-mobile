import 'package:base42_events_mobile/models/user.dart';

// Strapi returns { user: User, jwt: String, expiresIn?: int }
class AuthResponse {
  final User user;
  final String jwt;
  final int? expiresIn;

  AuthResponse({required this.user, required this.jwt, this.expiresIn});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      jwt: json['jwt'],
      expiresIn: json['expiresIn'],
    );
  }
}

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
