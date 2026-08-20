import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { outlined, filled, solid, attendance }

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
    bool fullWidth = false,
  }) {
    return CustomButton(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
      variant: ButtonVariant.attendance,
      isActive: isActive,
      isLoading: isLoading,
      fullWidth: fullWidth,
    );
  }

  factory CustomButton.action({
    IconData? icon,
    required String label,
    Color? color,
    required VoidCallback? onTap,
    required ButtonVariant variant,
    bool isLoading = false,
    bool fullWidth = true,
  }) {
    return CustomButton(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
      variant: variant,
      fullWidth: fullWidth,
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
      case ButtonVariant.attendance:
        return isActive
            ? _buildSolidButton(context, effectiveColor)
            : _buildOutlinedButton(context, effectiveColor);
    }
  }

  Widget _buildOutlinedButton(BuildContext context, Color effectiveColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive
              ? effectiveColor.withValues(alpha: 0.15)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive ? effectiveColor : colorScheme.outline,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: fullWidth
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? effectiveColor
                    : onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: FontSizes.bodySmall,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive
                    ? effectiveColor
                    : onSurface.withValues(alpha: 0.7),
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
                      label.toUpperCase(),
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
                    label.toUpperCase(),
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
    final textColor = effectiveColor.readableForeground();

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
                      label.toUpperCase(),
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
                    label.toUpperCase(),
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
