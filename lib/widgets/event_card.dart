import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/event_media_hero.dart';
import 'package:base42_events_mobile/widgets/chip_label.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
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
                text: dateFormat.format(event.start),
                color: colorScheme.secondary,
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: ChipLabel(
                text: timeFormat.format(event.start),
                color: colorScheme.secondary,
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
                      colorScheme.shadow.withValues(alpha: 0.0),
                      colorScheme.shadow.withValues(alpha: 0.58),
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
                textAlign: TextAlign.center,
                style: context.textStyles.titleLarge?.bold.withColor(
                  colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
