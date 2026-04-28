import 'package:base42_events_mobile/models/project_contributor.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';

class ProjectDetailsContributors extends StatelessWidget {
  final List<ProjectContributor> contributors;

  const ProjectDetailsContributors({super.key, required this.contributors});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleContributors = contributors.take(3).toList();
    final hiddenCount = contributors.length - visibleContributors.length;

    if (visibleContributors.isEmpty) {
      return Text(
        'No contributors found',
        style: context.textStyles.labelMedium?.withColor(
          colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      );
    }

    return SizedBox(
      height: 38,
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Stack(
              children: [
                for (var index = 0; index < visibleContributors.length; index++)
                  Positioned(
                    left: (index * 24).toDouble(),
                    child: _ContributorAvatar(
                      contributor: visibleContributors[index],
                    ),
                  ),
              ],
            ),
          ),
          if (hiddenCount > 0)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.45),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '+$hiddenCount',
                style: context.textStyles.labelSmall?.semiBold.withColor(
                  colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContributorAvatar extends StatelessWidget {
  final ProjectContributor contributor;

  const _ContributorAvatar({required this.contributor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.surface, width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          contributor.avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) {
            return ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.person_rounded,
                size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.52),
              ),
            );
          },
        ),
      ),
    );
  }
}
