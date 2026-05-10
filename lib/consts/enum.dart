enum EventAttendanceStatus { interested, going }

enum BookingFilter { upcoming, past }

const Map<EventAttendanceStatus, String> _eventAttendanceStatusLabels = {
  EventAttendanceStatus.interested: 'Interested',
  EventAttendanceStatus.going: 'Going',
};

String eventAttendanceStatusLabel(EventAttendanceStatus status) {
  return _eventAttendanceStatusLabels[status] ?? status.name;
}

String changeEventAttendanceStatus(EventAttendanceStatus status) {
  if (status == EventAttendanceStatus.interested) {
    return 'Switch to Going';
  } else {
    return 'Switch to Interested';
  }
}
