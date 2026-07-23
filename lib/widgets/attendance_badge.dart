import 'package:flutter/material.dart';
import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/theme.dart';

class AttendanceBadge extends StatelessWidget {
  final EventAttendanceStatus status;

  const AttendanceBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = switch (status) {
      EventAttendanceStatus.interested =>
        brand?.neonYellow ?? colorScheme.secondary,
      EventAttendanceStatus.going => brand?.neonCyan ?? colorScheme.primary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: Colors.black),
          const SizedBox(width: 3),
          Text(
            status.label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}