import 'package:flutter/material.dart';

String bookingFormatDate(DateTime date) {
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  final yyyy = date.year.toString();
  return '$mm/$dd/$yyyy';
}

String bookingFormatDateForApi(DateTime date) {
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  final yyyy = date.year.toString();
  return '$yyyy-$mm-$dd';
}

String bookingFormatTime(TimeOfDay time) {
  final hh = time.hour.toString().padLeft(2, '0');
  final mm = time.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}

String? bookingRequiredFieldValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required field';
  }
  return null;
}

String? bookingEmailValidator(String? value) {
  final input = value?.trim() ?? '';
  if (input.isEmpty) {
    return null;
  }

  final emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  if (!emailRegex.hasMatch(input)) {
    return 'Enter a valid email address';
  }

  return null;
}
