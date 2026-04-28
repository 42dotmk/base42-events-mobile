import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/services/projects_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/error_view.dart';
import 'package:base42_events_mobile/widgets/projects/projects_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final ProjectsService _projectsService = ProjectsService();
  List<ProjectRepo> _projects = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final projects = await _projectsService.fetchProjects();
      if (!mounted) return;
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openProject(ProjectRepo project) async {
    final owner = Uri.encodeComponent(project.ownerLogin);
    final repo = Uri.encodeComponent(project.name);
    context.push(AppRoutes.projectDetailsPath(owner, repo), extra: project);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projects',
                      style: context.textStyles.headlineSmall?.bold.withColor(
                        colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Active repositories from 42dotmk',
                      style: context.textStyles.bodySmall?.withColor(
                        colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : _errorMessage != null
                    ? ErrorView(
                        message: _errorMessage!,
                        onRetry: _loadProjects,
                        title: 'Failed to load projects',
                      )
                    : _projects.isEmpty
                    ? _EmptyProjectsState(onRetry: _loadProjects)
                    : RefreshIndicator(
                        onRefresh: _loadProjects,
                        color: colorScheme.primary,
                        child: ProjectsList(
                          projects: _projects,
                          onProjectTap: _openProject,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyProjectsState extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _EmptyProjectsState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspaces_outline,
              size: 42,
              color: colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 10),
            Text(
              'No active projects found',
              style: context.textStyles.titleMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
