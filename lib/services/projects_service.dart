import 'dart:convert';
import 'dart:developer' as developer;

import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/models/project_details.dart';
import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class ProjectsService {
  final AuthProvider _authProvider;

  ProjectsService(this._authProvider);

  Future<List<ProjectRepo>> fetchProjects() async {
    final token = await _authProvider.getAuthToken();

    developer.log(
      'fetchProjects: token = ${token != null ? '${token.substring(0, 20)}...${token.substring(token.length - 10)}' : 'NULL'}',
      name: 'ProjectsService',
    );

    if (token == null) {
      developer.log(
        'fetchProjects: No auth token available - user not authenticated or token expired',
        name: 'ProjectsService',
      );
      throw Exception('Not authenticated. Please login first.');
    }

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    developer.log(
      'fetchProjects: Making authenticated request to $projectsApiUrl',
      name: 'ProjectsService',
    );

    final response = await http.get(
      Uri.parse(projectsApiUrl),
      headers: headers,
    );

    developer.log(
      'fetchProjects: Response status = ${response.statusCode}',
      name: 'ProjectsService',
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 403 || response.statusCode == 401) {
        developer.log(
          'fetchProjects: Auth failed (${response.statusCode}). Check Strapi permissions.',
          name: 'ProjectsService',
        );
        throw Exception(
          'Projects API returned ${response.statusCode}. Check auth token and Strapi permissions.',
        );
      }
      throw Exception('Failed to load projects: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid projects response format');
    }

    final items = decoded['data'];

    if (items is! List) {
      throw Exception('Invalid projects response format');
    }

    final projects = items
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .map(ProjectRepo.fromJson)
        .toList();

    developer.log(
      'fetchProjects: Loaded ${projects.length} projects',
      name: 'ProjectsService',
    );

    projects.sort((a, b) {
      final left = a.pushedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final right = b.pushedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return right.compareTo(left);
    });

    return projects;
  }

  Future<ProjectDetails> fetchProjectDetails(ProjectRepo project) async {
    return ProjectDetails(
      project: project,
      openPullRequests: project.openPullRequests,
      helpWantedIssues: project.helpWantedIssues,
      contributors: project.contributors,
      commitActivity: project.commitActivity,
    );
  }
}
