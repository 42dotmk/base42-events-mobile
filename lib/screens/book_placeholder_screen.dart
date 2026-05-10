import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class BookPlaceholderScreen extends StatelessWidget {
  const BookPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.construction_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Booking feature is on a separate branch',
                    textAlign: TextAlign.center,
                    style: context.textStyles.titleLarge?.semiBold.withColor(
                      colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Switch to booking-feature to continue work on booking flows.',
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium?.withColor(
                      colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
