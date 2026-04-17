import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        ? 'Unknown update'
        : DateFormat('MMM d, yyyy').format(project.pushedAt!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.code_rounded, color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.titleMedium?.semiBold.withColor(
                      colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.description.isEmpty
                        ? 'No description available.'
                        : project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodySmall?.withColor(
                      colorScheme.onSurface.withValues(alpha: 0.68),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.memory_rounded,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.56),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        project.language,
                        style: context.textStyles.labelSmall?.withColor(
                          colorScheme.onSurface.withValues(alpha: 0.62),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.update_rounded,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.56),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pushedAtText,
                        style: context.textStyles.labelSmall?.withColor(
                          colorScheme.onSurface.withValues(alpha: 0.62),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new_rounded,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ],
        ),
      ),
    );
  }
}
