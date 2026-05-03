import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class StyledTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;

  const StyledTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      style: context.textStyles.titleLarge?.withColor(Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: context.textStyles.titleMedium?.withColor(
          (brand?.linkTextGray ?? colorScheme.primary).withValues(alpha: 0.85),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: (brand?.neonYellow ?? colorScheme.primary).withValues(
              alpha: 0.85,
            ),
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        errorStyle: context.textStyles.bodySmall?.withColor(colorScheme.error),
      ),
      validator: validator,
    );
  }
}
