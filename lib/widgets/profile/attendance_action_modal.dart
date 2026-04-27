import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';

class AttendanceActionModal extends StatelessWidget {
  final EventAttendanceStatus currentStatus;
  final VoidCallback onCancel;
  final VoidCallback onSwitch;

  const AttendanceActionModal({
    super.key,
    required this.currentStatus,
    required this.onCancel,
    required this.onSwitch,
  });

  String get _switchLabel {
    switch (currentStatus) {
      case EventAttendanceStatus.interested:
        return 'Switch to Going';
      case EventAttendanceStatus.going:
        return 'Switch to Interested';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Update Attendance',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton.action(
              label: _switchLabel,
              icon: Icons.swap_horiz_rounded,
              color: brand?.neonCyan ?? colorScheme.primary,
              onTap: () {
                Navigator.of(context).pop();
                onSwitch();
              },
            ),
            const SizedBox(height: 12),
            CustomButton.action(
              label: 'Cancel Attendance',
              icon: Icons.close_rounded,
              color: colorScheme.error,
              onTap: () {
                Navigator.of(context).pop();
                onCancel();
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Dismiss',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
