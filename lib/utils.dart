import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:base42_events_mobile/models/user.dart';

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

String buildUserDisplayName(User? user) {
  final firstName = (user?.firstName ?? '').trim();
  final surname = (user?.surname ?? '').trim();
  final fullName = [firstName, surname]
      .where((part) => part.isNotEmpty)
      .join(' ')
      .trim();
  if (fullName.isNotEmpty) return fullName;

  final fallback = (user?.username ?? '').trim();
  return fallback.isNotEmpty ? fallback : 'Guest User';
}

String buildUserInitials(String displayName) {
  final parts = displayName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return letters.isEmpty ? 'GU' : letters;
}

String sanitizeEventDescription(String raw) {
  var value = raw.replaceAll(
    RegExp(r'<style[^>]*>[\s\S]*?<\/style>', caseSensitive: false),
    '',
  );
  value = value.replaceFirst(RegExp(r'^\s*(?:[^<\n\r{}]+\{[^}]*\}\s*)+'), '');
  value = value.replaceAll(RegExp(r'\s*##+\s*'), '\n\n');
  return value.trim();
}

String buildEventDescriptionPreview(String raw) {
  final sanitized = sanitizeEventDescription(raw);
  final withoutBreaks = sanitized
      .replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</\s*p\s*>', caseSensitive: false), '\n\n')
      .replaceAll(RegExp(r'</\s*li\s*>', caseSensitive: false), '\n');
  final withoutTags = withoutBreaks.replaceAll(RegExp(r'<[^>]*>'), '');
  return withoutTags
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}

String buildEventDescriptionHtml(String raw) {
  final sanitized = sanitizeEventDescription(raw);
  final hasHtmlTag = RegExp(r'<[a-zA-Z][^>]*>').hasMatch(sanitized);
  if (hasHtmlTag) {
    return sanitized
        .replaceAll('\r\n', '\n')
        .replaceAll('\n\n', '<br/><br/>')
        .replaceAll('\n', '<br/>');
  }

  final escaped = const HtmlEscape(HtmlEscapeMode.element).convert(sanitized);
  final paragraphs = escaped
      .split(RegExp(r'\n\s*\n'))
      .where((p) => p.trim().isNotEmpty)
      .map((p) => '<p>${p.replaceAll('\n', '<br/>')}</p>')
      .join();
  return paragraphs.isEmpty ? '<p></p>' : paragraphs;
}
