import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

enum BookMode { coworking, hostEvent }

class ModeSwitcher extends StatelessWidget {
  final BookMode mode;
  final ValueChanged<BookMode> onChanged;

  const ModeSwitcher({super.key, required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? colorScheme.secondary : colorScheme.primary;
    final secondaryAccent = colorScheme.primary;
    final onSurface = colorScheme.onSurface;

    Widget buildButton(BookMode buttonMode, String label, IconData icon) {
      final selected = mode == buttonMode;
      final selectedColor = buttonMode == BookMode.coworking
          ? primaryAccent
          : secondaryAccent;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(buttonMode),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? selectedColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? colorScheme.onPrimary
                      : onSurface.withValues(alpha: 0.56),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: context.textStyles.labelLarge?.semiBold.withColor(
                    selected
                        ? colorScheme.onPrimary
                        : onSurface.withValues(alpha: 0.56),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          buildButton(BookMode.hostEvent, 'Booking', Icons.event_note_outlined),
          const SizedBox(width: 4),
          buildButton(BookMode.coworking, 'Coworking', Icons.monitor_outlined),
        ],
      ),
    );
  }
}
