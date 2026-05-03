import 'package:base42_events_mobile/models/event.dart';

class UserEvent {
  int userId;
  int eventId;
  String status;

  UserEvent({
    required this.userId,
    required this.eventId,
    required this.status,
  });

  factory UserEvent.fromJson(Map<String, dynamic> json) => UserEvent(
    userId: json["userId"],
    eventId: json["eventId"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'eventId': eventId,
    'status': status,
  };
}

class UserEventWithDetails {
  final Event event;
  final String status;

  UserEventWithDetails({required this.event, required this.status});

  int get eventId => event.id;
}

class UserEventResponse {
  final int eventId;
  final String status;

  UserEventResponse({required this.eventId, required this.status});
}
