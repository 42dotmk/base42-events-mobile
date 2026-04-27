enum EventAttendanceStatus { interested, going }

const Map<EventAttendanceStatus, String> _eventAttendanceStatusLabels = {
  EventAttendanceStatus.interested: 'Interested',
  EventAttendanceStatus.going: 'Going',
};

String eventAttendanceStatusLabel(EventAttendanceStatus status) {
  return _eventAttendanceStatusLabels[status] ?? status.name;
}
