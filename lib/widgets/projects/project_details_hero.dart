import 'package:base42_events_mobile/models/project_details.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/projects/project_details_contributors.dart';
import 'package:flutter/material.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';

class ProjectDetailsHero extends StatelessWidget {
  final ProjectDetails details;
  final VoidCallback onJoinTap;

  const ProjectDetailsHero({
    super.key,
    required this.details,
    required this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final pullRequestText = '${details.openPullRequests} Open Pull Requests';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (details.helpWantedIssues > 0)
              _HeroBadge(
                label: 'HELP WANTED',
                color: colorScheme.secondary,
                textColor: colorScheme.onSecondary,
              ),
            _PullRequestsBadge(label: pullRequestText),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _GradientProjectTitle(
          text: details.project.name,
          endColor: brand?.neonYellow ?? colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          details.project.description.isEmpty
              ? 'No description available.'
              : details.project.description,
          style: context.textStyles.bodyLarge?.withColor(
            colorScheme.onSurface.withValues(alpha: 0.86),
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomButton.action(
          label: 'JOIN & CONTRIBUTE',
          variant: ButtonVariant.solid,
          onTap: onJoinTap,
        ),
        const SizedBox(height: AppSpacing.md),
        ProjectDetailsContributors(contributors: details.contributors),
      ],
    );
  }
}

class _GradientProjectTitle extends StatelessWidget {
  final String text;
  final Color endColor;

  const _GradientProjectTitle({required this.text, required this.endColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = context.textStyles.displaySmall?.semiBold;

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.onSurface.withValues(alpha: 0.98), endColor],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: textStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _HeroBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textStyles.labelSmall?.semiBold.withColor(textColor),
      ),
    );
  }
}

class _PullRequestsBadge extends StatelessWidget {
  final String label;

  const _PullRequestsBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: colorScheme.secondary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: context.textStyles.titleSmall?.medium.withColor(
            colorScheme.onSurface.withValues(alpha: 0.92),
          ),
        ),
      ],
    );
  }
}
