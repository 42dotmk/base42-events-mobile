import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPromptDialog extends StatelessWidget {
  final String message;

  const AuthPromptDialog({
    super.key,
    this.message = 'Sign in to access this feature',
  });

  static Future<void> show(BuildContext context, {String? message}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AuthPromptDialog(
        message: message ?? 'Sign in to access this feature',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 28,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Authentication Required',
              style: context.textStyles.titleLarge?.bold.withColor(
                colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomButton.action(
              label: 'Sign In',
              variant: ButtonVariant.solid,
              onTap: () {
                Navigator.of(context).pop();
                final navContext = AppRouterHelper.rootNavigatorKey.currentContext;
                if (navContext != null) {
                  navContext.go(AppRoutes.auth);
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
