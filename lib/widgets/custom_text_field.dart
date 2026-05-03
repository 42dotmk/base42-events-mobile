import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/booking/booking_form_fields.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const CustomTextField({
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
