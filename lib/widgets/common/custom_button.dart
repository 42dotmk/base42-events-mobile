import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { outlined, filled }

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final bool isActive;
  final bool isLoading;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
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
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required ButtonVariant variant,
  }) {
    return CustomButton(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
      variant: variant,
      fullWidth: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (variant == ButtonVariant.outlined) {
      return _buildOutlinedButton(context);
    } else {
      return _buildFilledButton(context);
    }
  }

  Widget _buildOutlinedButton(BuildContext context) {
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
              ? color.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive ? color : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? color : Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.bodySmall,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? color : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledButton(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              if (fullWidth)
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
