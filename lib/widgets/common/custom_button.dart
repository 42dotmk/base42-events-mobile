import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { outlined, filled, solid }

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final bool isActive;
  final bool isLoading;
  final bool fullWidth;

  const CustomButton({
    super.key,
    this.icon,
    required this.label,
    this.color,
    this.onTap,
    this.variant = ButtonVariant.outlined,
    this.isActive = false,
    this.isLoading = false,
    this.fullWidth = false,
  });

  factory CustomButton.attendance({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isActive = false,
    bool isLoading = false,
  }) {
    return CustomButton(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
      variant: ButtonVariant.outlined,
      isActive: isActive,
      isLoading: isLoading,
    );
  }

  factory CustomButton.action({
    IconData? icon,
    required String label,
    Color? color,
    required VoidCallback? onTap,
    required ButtonVariant variant,
    bool isLoading = false,
  }) {
    return CustomButton(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
      variant: variant,
      fullWidth: true,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveColor = color ??
        (isDark
            ? (brand?.neonYellow ?? colorScheme.primary)
            : colorScheme.primary);

    switch (variant) {
      case ButtonVariant.outlined:
        return _buildOutlinedButton(context, effectiveColor);
      case ButtonVariant.filled:
        return _buildFilledButton(context, effectiveColor);
      case ButtonVariant.solid:
        return _buildSolidButton(context, effectiveColor);
    }
  }

  Widget _buildOutlinedButton(BuildContext context, Color effectiveColor) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? effectiveColor.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive
                ? effectiveColor
                : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? effectiveColor
                    : Colors.white.withValues(alpha: 0.6),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.bodySmall,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive
                    ? effectiveColor
                    : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledButton(BuildContext context, Color effectiveColor) {
    return Material(
      color: effectiveColor.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: effectiveColor,
                  ),
                )
              else ...[
                if (icon != null) ...[
                  Icon(icon, color: effectiveColor, size: 24),
                  const SizedBox(width: 12),
                ],
                if (fullWidth)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: effectiveColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: effectiveColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSolidButton(BuildContext context, Color effectiveColor) {
    final textColor =
        effectiveColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Material(
      color: effectiveColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                )
              else ...[
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 24),
                  const SizedBox(width: 12),
                ],
                if (fullWidth)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
