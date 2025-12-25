import 'package:flutter/material.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/services/event_service.dart';

class EventMediaHero extends StatelessWidget {
  final Event event;

  const EventMediaHero({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (event.promo != null) {
      final url =
          event.promo!.getMediumUrl(EventService.baseUrl) ??
          event.promo!.getFullUrl(EventService.baseUrl);
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _assetFallback(colorScheme),
      );
    }
    return _assetFallback(colorScheme);
  }

  Widget _assetFallback(ColorScheme colorScheme) => Image.asset(
    'assets/images/base42_placeholder.png',
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported,
        size: 64,
        color: colorScheme.outline,
      ),
    ),
  );
}
