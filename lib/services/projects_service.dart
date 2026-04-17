import 'dart:convert';

import 'package:base42_events_mobile/consts/api.dart';
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
}
