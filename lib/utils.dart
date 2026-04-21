import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

String projectListUpdatedLabel(DateTime? pushedAt) {
  if (pushedAt == null) {
    return 'RECENT';
  }

  return DateFormat('MMM yyyy').format(pushedAt).toUpperCase();
}

String projectLastSyncLabel(DateTime? pushedAt) {
  if (pushedAt == null) {
    return 'Unknown';
  }

  return DateFormat('MMM d, yyyy').format(pushedAt);
}

String projectStarsLabel(int value) {
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}k';
  }

  return value.toString();
}
