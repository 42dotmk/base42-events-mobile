import 'package:flutter/material.dart';

class EventAttendeeCount extends StatelessWidget {
  final int goingCount;
  final int interestedCount;

  const EventAttendeeCount({
    super.key,
    required this.goingCount,
    required this.interestedCount,
  });

  @override
  Widget build(BuildContext context) {
    final mutedWhite = Colors.white.withValues(alpha: 0.85);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (goingCount > 0) ...[
          Icon(Icons.check_circle_outline, size: 14, color: mutedWhite),
          const SizedBox(width: 4),
          Text(
            '$goingCount',
            style: TextStyle(fontSize: 12, color: mutedWhite),
          ),
          const SizedBox(width: 12),
        ],
        if (interestedCount > 0) ...[
          Icon(Icons.star_outline_rounded, size: 14, color: mutedWhite),
          const SizedBox(width: 4),
          Text(
            '$interestedCount',
            style: TextStyle(fontSize: 12, color: mutedWhite),
          ),
        ],
      ],
    );
  }
}
