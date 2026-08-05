import 'package:flutter/material.dart';

enum EventAttendanceStatus {
  interested(icon: Icons.star_rounded, label: 'Interested'),
  going(icon: Icons.check_circle_rounded, label: 'Going');

  final IconData icon;
  final String label;

  const EventAttendanceStatus({required this.icon, required this.label});
}

enum BookingFilter { upcoming, past }

String eventAttendanceStatusLabel(EventAttendanceStatus status) {
  return status.label;
}

String changeEventAttendanceStatus(EventAttendanceStatus status) {
  if (status == EventAttendanceStatus.interested) {
    return 'Switch to Going';
  } else {
    return 'Switch to Interested';
  }
}