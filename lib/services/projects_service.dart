import 'dart:convert';

import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/models/project_details.dart';
import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class ProjectsService {
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<ProjectRepo>> fetchProjects() async {
    final token = await _storageService.getToken(SecureStorageService.jwtTokenKey);

    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse(projectsApiUrl),
      headers: headers,
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 403 || response.statusCode == 401) {
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
