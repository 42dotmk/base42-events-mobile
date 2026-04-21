import 'dart:convert';

import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/models/project_commit_week.dart';
import 'package:base42_events_mobile/models/project_contributor.dart';
import 'package:base42_events_mobile/models/project_details.dart';
import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:http/http.dart' as http;

class ProjectsService {
  Future<List<ProjectRepo>> fetchProjects() async {
    final response = await http.get(Uri.parse(projectsApiUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load projects: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Invalid projects response format');
    }

    final projects = decoded
        .whereType<Map<String, dynamic>>()
        .map(ProjectRepo.fromJson)
        .where(
          (repo) =>
              !repo.fork &&
              !repo.archived &&
              repo.name.trim().isNotEmpty &&
              repo.htmlUrl.trim().isNotEmpty,
        )
        .toList();

    return projects;
  }

  //TODO: Handle errors better with popups.
  Future<ProjectDetails> fetchProjectDetails(ProjectRepo project) async {
    final owner = project.ownerLogin.trim();
    final repo = project.name.trim();

    if (owner.isEmpty || repo.isEmpty) {
      throw Exception('Invalid project owner or repository name');
    }

    final openPullRequestsFuture = fetchOpenPullRequests(owner, repo);
    final helpWantedFuture = fetchHelpWantedIssues(owner, repo);
    final contributorsFuture = fetchContributors(owner, repo);

    final results = await Future.wait<dynamic>([
      openPullRequestsFuture,
      helpWantedFuture,
      contributorsFuture,
    ]);

    return ProjectDetails(
      project: project,
      openPullRequests: results[0] as int,
      helpWantedIssues: results[1] as int,
      contributors: results[2] as List<ProjectContributor>,
      commitActivity: const [],
    );
  }

  Future<int> fetchOpenPullRequests(String owner, String repo) async {
    final uri = Uri.parse(projectOpenPullRequestsApiUrl(owner, repo));
    final response = await http.get(uri);

    final decoded = _readJsonObject(response, 'open pull requests');
    return decoded['total_count'] as int? ?? 0;
  }

  Future<int> fetchHelpWantedIssues(String owner, String repo) async {
    final uri = Uri.parse(projectHelpWantedIssuesApiUrl(owner, repo));
    final response = await http.get(uri);

    final decoded = _readJsonObject(response, 'help wanted issues');
    return decoded['total_count'] as int? ?? 0;
  }

  Future<List<ProjectContributor>> fetchContributors(
    String owner,
    String repo,
  ) async {
    final uri = Uri.parse(projectContributorsApiUrl(owner, repo));
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load contributors: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Invalid contributors response format');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ProjectContributor.fromJson)
        .where((contributor) => contributor.avatarUrl.trim().isNotEmpty)
        .toList();
  }

  Future<List<ProjectCommitWeek>?> fetchCommitActivity(
    String owner,
    String repo,
  ) async {
    final uri = Uri.parse(projectCommitActivityApiUrl(owner, repo));
    final response = await http.get(uri);

    if (response.statusCode == 202) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load commit activity: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Invalid commit activity response format');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ProjectCommitWeek.fromJson)
        .toList();
  }

  Map<String, dynamic> _readJsonObject(http.Response response, String label) {
    if (response.statusCode != 200) {
      throw Exception('Failed to load $label: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid $label response format');
    }

    return decoded;
  }
}
