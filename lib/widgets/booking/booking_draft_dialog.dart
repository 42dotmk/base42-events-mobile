import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';

enum BookingDraftDecision { saveDraft, discardDraft }

class BookingDraftDialog extends StatelessWidget {
  const BookingDraftDialog({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave booking form?',
              style: context.textStyles.titleLarge?.bold.withColor(
                colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You have unsaved booking details. Do you want to save this draft or discard it?',
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomButton.action(
              label: 'Save Draft',
              variant: ButtonVariant.solid,
              onTap: () =>
                  Navigator.pop(context, BookingDraftDecision.saveDraft),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () =>
                    Navigator.pop(context, BookingDraftDecision.discardDraft),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.errorContainer,
                  foregroundColor: colorScheme.onErrorContainer,
                ),
                child: const Text('Discard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<BookingDraftDecision> showBookingDraftDialog({
  required BuildContext context,
}) async {
  final result = await showDialog<BookingDraftDecision>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const BookingDraftDialog(),
  );

  return result ?? BookingDraftDecision.saveDraft;
}
