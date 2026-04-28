import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class SectionHeaderRow extends StatelessWidget {
  final String title;
  final String trailingLabel;
  final Color trailingColor;
  final VoidCallback? onTap;

  const SectionHeaderRow({
    super.key,
    required this.title,
    required this.trailingLabel,
    required this.trailingColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          trailingLabel,
          style: context.textStyles.titleMedium?.medium.withColor(
            trailingColor,
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: trailingColor),
      ],
    );

    return Row(
      children: [
        Text(
          title,
          style: context.textStyles.titleMedium?.semiBold.withColor(
            colorScheme.onSurface.withValues(alpha: 0.78),
          ),
        ),
        const Spacer(),
        if (onTap == null)
          trailing
        else
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: trailing,
          ),
      ],
    );
  }
}
