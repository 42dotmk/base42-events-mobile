import 'package:flutter/material.dart';
import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/theme.dart';

class AttendanceBadge extends StatelessWidget {
  final EventAttendanceStatus status;

  const AttendanceBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = colorScheme.primary;
    final textColor = bgColor.readableForeground();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: textColor),
          const SizedBox(width: 3),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}