import 'package:base42_events_mobile/models/project_commit_week.dart';
import 'package:base42_events_mobile/models/project_contributor.dart';
import 'package:base42_events_mobile/models/project_repo.dart';

class ProjectDetails {
  final ProjectRepo project;
  final int openPullRequests;
  final int helpWantedIssues;
  final List<ProjectContributor> contributors;
  final List<ProjectCommitWeek> commitActivity;

  const ProjectDetails({
    required this.project,
    required this.openPullRequests,
    required this.helpWantedIssues,
    required this.contributors,
    required this.commitActivity,
  });

  ProjectDetails copyWith({
    int? openPullRequests,
    int? helpWantedIssues,
    List<ProjectContributor>? contributors,
    List<ProjectCommitWeek>? commitActivity,
  }) {
    return ProjectDetails(
      project: project,
      openPullRequests: openPullRequests ?? this.openPullRequests,
      helpWantedIssues: helpWantedIssues ?? this.helpWantedIssues,
      contributors: contributors ?? this.contributors,
      commitActivity: commitActivity ?? this.commitActivity,
    );
  }
}
