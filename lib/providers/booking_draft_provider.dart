import 'package:flutter/material.dart';

class BookingDraftProvider extends ChangeNotifier {
  String organizerEntity = '';
  String initiatorName = '';
  String email = '';
  String phone = '';
  String companyName = '';
  String eventName = '';
  String eventTheme = '';
  String eventPurpose = '';
  String eventAgenda = '';
  String expectedGuests = '';

  String? eventType;
  DateTime? eventDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String physicalPresence = 'yes';

  bool get hasDraft {
    return organizerEntity.trim().isNotEmpty ||
        initiatorName.trim().isNotEmpty ||
        email.trim().isNotEmpty ||
        phone.trim().isNotEmpty ||
        companyName.trim().isNotEmpty ||
        eventName.trim().isNotEmpty ||
        eventTheme.trim().isNotEmpty ||
        eventPurpose.trim().isNotEmpty ||
        eventAgenda.trim().isNotEmpty ||
        expectedGuests.trim().isNotEmpty ||
        eventType != null ||
        eventDate != null ||
        startTime != null ||
        endTime != null ||
        physicalPresence != 'yes';
  }

  void setOrganizerEntity(String value) => _setString(
    current: organizerEntity,
    next: value,
    apply: (v) => organizerEntity = v,
  );

  void setInitiatorName(String value) => _setString(
    current: initiatorName,
    next: value,
    apply: (v) => initiatorName = v,
  );

  void setEmail(String value) =>
      _setString(current: email, next: value, apply: (v) => email = v);

  void setPhone(String value) =>
      _setString(current: phone, next: value, apply: (v) => phone = v);

  void setCompanyName(String value) => _setString(
    current: companyName,
    next: value,
    apply: (v) => companyName = v,
  );

  void setEventName(String value) =>
      _setString(current: eventName, next: value, apply: (v) => eventName = v);

  void setEventTheme(String value) => _setString(
    current: eventTheme,
    next: value,
    apply: (v) => eventTheme = v,
  );

  void setEventPurpose(String value) => _setString(
    current: eventPurpose,
    next: value,
    apply: (v) => eventPurpose = v,
  );

  void setEventAgenda(String value) => _setString(
    current: eventAgenda,
    next: value,
    apply: (v) => eventAgenda = v,
  );

  void setExpectedGuests(String value) => _setString(
    current: expectedGuests,
    next: value,
    apply: (v) => expectedGuests = v,
  );

  void setEventType(String? value) {
    if (eventType == value) return;
    eventType = value;
    notifyListeners();
  }

  void setEventDate(DateTime? value) {
    if (eventDate == value) return;
    eventDate = value;
    notifyListeners();
  }

  void setStartTime(TimeOfDay? value) {
    if (_sameTime(startTime, value)) return;
    startTime = value;
    notifyListeners();
  }

  void setEndTime(TimeOfDay? value) {
    if (_sameTime(endTime, value)) return;
    endTime = value;
    notifyListeners();
  }

  void setPhysicalPresence(String value) {
    if (physicalPresence == value) return;
    physicalPresence = value;
    notifyListeners();
  }

  void clear() {
    organizerEntity = '';
    initiatorName = '';
    email = '';
    phone = '';
    companyName = '';
    eventName = '';
    eventTheme = '';
    eventPurpose = '';
    eventAgenda = '';
    expectedGuests = '';
    eventType = null;
    eventDate = null;
    startTime = null;
    endTime = null;
    physicalPresence = 'yes';
    notifyListeners();
  }

  void _setString({
    required String current,
    required String next,
    required void Function(String) apply,
  }) {
    if (current == next) return;
    apply(next);
    notifyListeners();
  }

  bool _sameTime(TimeOfDay? a, TimeOfDay? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.hour == b.hour && a.minute == b.minute;
  }
}
