import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AccountMenuItem {
  final IconData icon;
  final String label;
  final String description;
  final String? route;

  const AccountMenuItem({
    required this.icon,
    required this.label,
    required this.description,
    this.route,
  });
}

class AccountMenuTile extends StatelessWidget {
  final AccountMenuItem item;

  const AccountMenuTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        if (item.route != null) context.push(item.route!);
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.62,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item.icon,
                color: Colors.white.withValues(alpha: 0.48),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: context.textStyles.headlineSmall?.semiBold
                        .withSize(37 / 2)
                        .withColor(Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: context.textStyles.titleLarge?.withColor(
                      Colors.white.withValues(alpha: 0.46),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.22),
            ),
          ],
        ),
      ),
    );
  }
}
