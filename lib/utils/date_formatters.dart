import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatMonthAbbr(DateTime date) {
  return DateFormat('MMM').format(date).toUpperCase();
}

String formatMonthDay(DateTime date) {
  return DateFormat('MMM dd').format(date);
}

String formatMonthYear(DateTime date) {
  return DateFormat('MMM yyyy').format(date).toUpperCase();
}

String formatDateMedium(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

String formatDateFull(DateTime date) {
  return DateFormat('EEEE, MMMM dd, yyyy \u2022 hh:mm a').format(date);
}

String formatDateNumeric(DateTime date) {
  return DateFormat('dd.MM.yyyy').format(date);
}

String formatDateSlash(DateTime date) {
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  final yyyy = date.year.toString();
  return '$mm/$dd/$yyyy';
}

String formatDateIso(DateTime date) {
  final yyyy = date.year.toString().padLeft(4, '0');
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  return '$yyyy-$mm-$dd';
}

String formatTime24(DateTime date) {
  return DateFormat('HH:mm').format(date);
}

String formatTimeOfDay(TimeOfDay time) {
  final hh = time.hour.toString().padLeft(2, '0');
  final mm = time.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}
