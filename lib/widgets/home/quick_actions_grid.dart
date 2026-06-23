import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/widgets/quick_action_tile.dart';
import 'package:base42_events_mobile/widgets/section_header_row.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final actions = [
      _ActionItem(
        icon: Icons.monitor_outlined,
        label: 'Book Event',
        route: '/book',
        color: colorScheme.primary,
      ),
      _ActionItem(
        icon: Icons.volunteer_activism_outlined,
        label: 'Volunteer',
        route: '/volunteer',
        color: colorScheme.primary,
      ),
      _ActionItem(
        icon: Icons.card_membership_outlined,
        label: 'Member',
        route: '/member',
        color: colorScheme.primary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderRow(
          title: "QUICK ACTIONS",
          trailingColor: Colors.transparent,
          trailingLabel: ' ',
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return QuickActionTile(
              icon: action.icon,
              label: action.label,
              color: action.color,
              onTap: () {
                if (action.route != null) {
                  context.push(action.route!);
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${action.label} is coming soon'),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String? route;
  final Color color;

  const _ActionItem({
    required this.icon,
    required this.label,
    this.route,
    required this.color,
  });
}
