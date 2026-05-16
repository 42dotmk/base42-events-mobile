import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/widgets/projects/project_list_item.dart';
import 'package:flutter/material.dart';

class ProjectsList extends StatelessWidget {
  final List<ProjectRepo> projects;
  final Future<void> Function(ProjectRepo project) onProjectTap;

  const ProjectsList({
    super.key,
    required this.projects,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      itemCount: projects.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectListItem(
          project: project,
          onTap: () {
            onProjectTap(project);
          },
        );
      },
    );
  }
}
