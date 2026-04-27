import 'package:base42_events_mobile/models/project_commit_week.dart';
import 'package:base42_events_mobile/models/project_contributor.dart';

class ProjectRepo {
  final String ownerLogin;
  final String name;
  final String description;
  final String htmlUrl;
  final String language;
  final int stargazersCount;
  final DateTime? pushedAt;
  final int openPullRequests;
  final int helpWantedIssues;
  final List<ProjectContributor> contributors;
  final List<ProjectCommitWeek> commitActivity;
  final bool fork;
  final bool archived;

  const ProjectRepo({
    required this.ownerLogin,
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.language,
    required this.stargazersCount,
    required this.pushedAt,
    required this.openPullRequests,
    required this.helpWantedIssues,
    required this.contributors,
    required this.commitActivity,
    required this.fork,
    required this.archived,
  });

  factory ProjectRepo.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>?;
    final data = attributes ?? json;
    final owner = data['owner'] as Map<String, dynamic>?;

    final contributorsData = data['contributors'];
    final contributors = contributorsData is List
        ? contributorsData
              .whereType<Map>()
              .map(
                (entry) => ProjectContributor.fromJson(
                  Map<String, dynamic>.from(entry),
                ),
              )
              .toList()
        : const <ProjectContributor>[];

    final commitActivityData =
        data['commit_activity'] ?? data['commitActivity'];
    final commitActivity = commitActivityData is List
        ? commitActivityData
              .whereType<Map>()
              .map(
                (entry) => ProjectCommitWeek.fromJson(
                  Map<String, dynamic>.from(entry),
                ),
              )
              .toList()
        : const <ProjectCommitWeek>[];

    String? asString(dynamic value) => value is String ? value : null;
    int asInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    final resolvedOwner =
        asString(data['owner_login']) ??
        asString(data['ownerLogin']) ??
        asString(owner?['login']) ??
        'base42';
    final resolvedName = asString(data['name']) ?? '';

    // Build GitHub URL from known pattern if not provided
    final resolvedHtmlUrl =
        asString(data['html_url']) ??
        asString(data['htmlUrl']) ??
        asString(data['url']) ??
        (resolvedOwner.isNotEmpty && resolvedName.isNotEmpty
            ? 'https://github.com/$resolvedOwner/$resolvedName'
            : '');

    return ProjectRepo(
      ownerLogin: resolvedOwner,
      name: resolvedName,
      description: asString(data['description']) ?? '',
      htmlUrl: resolvedHtmlUrl,
      language: asString(data['language']) ?? 'Unknown',
      stargazersCount:
          asInt(data['stargazers_count']) + asInt(data['stargazersCount']),
      pushedAt: DateTime.tryParse(
        asString(data['pushed_at']) ??
            asString(data['last_synced_at']) ??
            asString(data['updatedAt']) ??
            '',
      ),
      openPullRequests:
          asInt(data['pr_count']) + asInt(data['open_pull_requests']),
      helpWantedIssues:
          asInt(data['help_wanted_count']) + asInt(data['help_wanted_issues']),
      contributors: contributors,
      commitActivity: commitActivity,
      fork: data['fork'] as bool? ?? false,
      archived: data['archived'] as bool? ?? false,
    );
  }
}
