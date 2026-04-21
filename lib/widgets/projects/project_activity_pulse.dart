import 'package:base42_events_mobile/models/project_commit_week.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class ProjectActivityPulse extends StatelessWidget {
  final List<ProjectCommitWeek> activity;
  final bool isLoading;

  const ProjectActivityPulse({
    super.key,
    required this.activity,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bars = _buildBars();

    if (bars.isEmpty && !isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            'No activity data available yet',
            style: context.textStyles.labelMedium?.withColor(
              colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
      );
    }

    final maxTotal = bars.isEmpty
        ? 1
        : bars.map((entry) => entry.total).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: bars.map((week) {
              final heightFactor = maxTotal == 0 ? 0.2 : week.total / maxTotal;
              final color = isLoading
                  ? colorScheme.onSurface.withValues(alpha: 0.16)
                  : colorScheme.primary.withValues(
                      alpha: 0.3 + (heightFactor * 0.55),
                    );

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 24 + (heightFactor * 96),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            isLoading ? 'LOADING ACTIVITY...' : 'ACTIVITY PULSE',
            style: context.textStyles.labelSmall?.medium.withColor(
              colorScheme.onSurface.withValues(alpha: 0.42),
            ),
          ),
        ),
      ],
    );
  }

  List<ProjectCommitWeek> _buildBars() {
    if (isLoading) {
      return const [
        ProjectCommitWeek(week: 0, total: 3),
        ProjectCommitWeek(week: 0, total: 5),
        ProjectCommitWeek(week: 0, total: 4),
        ProjectCommitWeek(week: 0, total: 7),
        ProjectCommitWeek(week: 0, total: 6),
        ProjectCommitWeek(week: 0, total: 2),
      ];
    }

    if (activity.length <= 6) {
      return activity;
    }

    return activity.sublist(activity.length - 6);
  }
}
