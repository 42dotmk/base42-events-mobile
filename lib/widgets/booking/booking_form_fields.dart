import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

InputDecoration bookingInputDecoration(BuildContext context, String label) {
  final colorScheme = Theme.of(context).colorScheme;

  return InputDecoration(
    labelText: label,
    labelStyle: context.textStyles.bodySmall?.withColor(
      colorScheme.onSurface.withValues(alpha: 0.62),
    ),
    filled: true,
    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.8)),
    ),
  );
}

class BookingHostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const BookingHostTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.words,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: context.textStyles.bodyMedium?.withColor(colorScheme.onSurface),
        decoration: bookingInputDecoration(context, label),
      ),
    );
  }
}

class BookingDateTimeButtonField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const BookingDateTimeButtonField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: bookingInputDecoration(context, label),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: context.textStyles.bodyMedium?.withColor(
                    colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.calendar_month_outlined,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
