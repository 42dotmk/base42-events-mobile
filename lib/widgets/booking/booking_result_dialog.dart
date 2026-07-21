import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';

enum BookingResultType { success, error }

class BookingResultDialog extends StatelessWidget {
  final BookingResultType type;
  final String? customMessage;

  const BookingResultDialog({
    super.key,
    required this.type,
    this.customMessage,
  });

  String get _title => type == BookingResultType.success
      ? 'Request Submitted'
      : 'Submission Failed';

  String get _message =>
      customMessage ??
      (type == BookingResultType.success
          ? 'Your event request has been submitted successfully. We\'ll review it and get back to you soon.'
          : 'We encountered an issue while submitting your request. Please try again.');

  IconData get _icon => type == BookingResultType.success
      ? Icons.check_circle_outline
      : Icons.error_outline;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    final iconColor = type == BookingResultType.success
        ? brand?.successGreen ?? colorScheme.secondary
        : brand?.errorRed ?? colorScheme.error;

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
            Icon(_icon, size: 64, color: iconColor),
            const SizedBox(height: AppSpacing.md),
            Text(
              _title,
              style: context.textStyles.titleLarge?.bold.withColor(
                colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _message,
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            CustomButton.action(
              label: type == BookingResultType.success ? 'Done' : 'Try Again',
              variant: ButtonVariant.solid,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

void showBookingResultDialog({
  required BuildContext context,
  required BookingResultType type,
  String? customMessage,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        BookingResultDialog(type: type, customMessage: customMessage),
  );
}
