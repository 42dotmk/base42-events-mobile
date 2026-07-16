import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/utils/date_formatters.dart';
import 'package:flutter/material.dart';

class ProjectListItem extends StatelessWidget {
  final ProjectRepo project;
  final VoidCallback onTap;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pushedAtText = project.pushedAt == null
        ? 'RECENT'
        : formatMonthYear(project.pushedAt!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              project.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.headlineSmall?.semiBold.withColor(
                colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              project.description.isEmpty
                  ? 'No description available.'
                  : project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.data_object_rounded,
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.56),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  project.language,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleSmall?.medium.withColor(
                    colorScheme.onSurface.withValues(alpha: 0.76),
                  ),
                ),
                const Spacer(),
                Text(
                  pushedAtText,
                  style: context.textStyles.labelSmall?.medium.withColor(
                    colorScheme.onSurface.withValues(alpha: 0.48),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
