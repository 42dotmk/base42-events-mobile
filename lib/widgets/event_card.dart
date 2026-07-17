import 'package:flutter/material.dart';
import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/utils/date_formatters.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/event_media_hero.dart';
import 'package:base42_events_mobile/widgets/chip_label.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final EventAttendanceStatus? attendanceStatus;
  final bool isPast;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.attendanceStatus,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final card = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.22),
              blurRadius: 18,
              spreadRadius: 0.5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        foregroundDecoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.4),
              width: 1.6,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: EventMediaHero(event: event),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: ChipLabel(
                text: formatDateNumeric(event.start),
                color: Colors.white,
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChipLabel(
                    text: formatTime24(event.start),
                    color: Colors.white,
                  ),
                  if (attendanceStatus != null) ...[
                    const SizedBox(width: 6),
                    _AttendanceBadge(status: attendanceStatus!),
                  ],
                ],
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colorScheme.shadow.withValues(alpha: 0.18),
                      colorScheme.shadow.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Text(
                event.title,
                textAlign: TextAlign.left,
                style: context.textStyles.titleLarge?.bold.withColor(
                  Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    return isPast
        ? ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: card,
          )
        : card;
  }
}

class _AttendanceBadge extends StatelessWidget {
  final EventAttendanceStatus status;

  const _AttendanceBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    final (icon, label, bgColor) = switch (status) {
      EventAttendanceStatus.interested => (
        Icons.star_rounded,
        'Interested',
        brand?.neonYellow ?? colorScheme.secondary,
      ),
      EventAttendanceStatus.going => (
        Icons.check_circle_rounded,
        'Going',
        brand?.neonCyan ?? colorScheme.primary,
      ),
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
          Icon(icon, size: 12, color: Colors.black),
          const SizedBox(width: 3),
          Text(
            label,
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
