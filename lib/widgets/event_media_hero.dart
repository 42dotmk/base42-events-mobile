import 'package:base42_events_mobile/consts/api.dart';
import 'package:flutter/material.dart';
import 'package:base42_events_mobile/models/event.dart';

class EventMediaHero extends StatelessWidget {
  final Event event;

  const EventMediaHero({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (event.promo != null) {
      final url =
          event.promo!.getMediumUrl(baseUrl) ??
          event.promo!.getFullUrl(baseUrl);
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _assetFallback(colorScheme),
      );
    }
    return _assetFallback(colorScheme);
  }

  Widget _assetFallback(ColorScheme colorScheme) => Image.asset(
    'assets/images/base42_placeholder.png',
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported,
        size: 64,
        color: colorScheme.outline,
      ),
    ),
  );
}
