import 'package:flutter/material.dart';

import '../../theme.dart';

class OnboardingActionButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onPressed;
  final String? doneButtonLabel;

  const OnboardingActionButton({
    super.key,
    required this.isLast,
    required this.onPressed,
    this.doneButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final cyan = brand?.neonCyan ?? colorScheme.primary;
    final yellow = brand?.neonYellow ?? colorScheme.secondary;

    final activeColor = isLast ? yellow : cyan;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isLast
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 15)
            : const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(isLast ? 16 : 50),
          boxShadow: [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLast
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    doneButtonLabel ?? 'Done',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: colorScheme.onPrimary,
                    size: 18,
                  ),
                ],
              )
            : const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.black,
                size: 22,
              ),
      ),
    );
  }
}
