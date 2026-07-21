import 'package:flutter/material.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    this.title = 'Failed to load events',
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: context.textStyles.titleLarge?.semiBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: context.textStyles.bodyMedium?.withColor(
                Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomButton.action(
              icon: Icons.refresh_rounded,
              label: 'Retry',
              variant: ButtonVariant.solid,
              onTap: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
