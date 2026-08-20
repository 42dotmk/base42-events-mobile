import 'package:base42_events_mobile/models/project_details.dart';
import 'package:base42_events_mobile/models/project_repo.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/services/projects_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/utils/date_formatters.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:base42_events_mobile/widgets/error_view.dart';
import 'package:base42_events_mobile/widgets/projects/project_activity_pulse.dart';
import 'package:base42_events_mobile/widgets/projects/project_details_hero.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectRepo project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late final ProjectsService _projectsService;

  ProjectDetails? _details;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _projectsService = ProjectsService(authProvider);
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final details = await _projectsService.fetchProjectDetails(
        widget.project,
      );
      if (!mounted) return;

      setState(() {
        _details = details;
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

  Future<void> _openProjectUrl() async {
    final uri = Uri.parse(widget.project.htmlUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open project link.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: 'Project Details',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(child: _buildBody(context)),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    if (_errorMessage != null) {
      return ErrorView(
        title: 'Failed to load project details',
        message: _errorMessage!,
        onRetry: _loadDetails,
      );
    }

    final details = _details;
    if (details == null) {
      return ErrorView(
        title: 'Project details unavailable',
        message: 'Unable to prepare project details view.',
        onRetry: _loadDetails,
      );
    }

    final pushedAtText = details.project.pushedAt == null
        ? 'Unknown'
        : formatDateMedium(details.project.pushedAt!);

    return RefreshIndicator(
      onRefresh: _loadDetails,
      color: colorScheme.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.45,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProjectDetailsHero(
                  details: details,
                  onJoinTap: _openProjectUrl,
                ),
                const SizedBox(height: AppSpacing.lg),
                Divider(color: colorScheme.outline.withValues(alpha: 0.22)),
                const SizedBox(height: AppSpacing.lg),
                _StatsRow(label: 'Language', value: details.project.language),
                const SizedBox(height: AppSpacing.lg),
                _StatsRow(
                  label: 'Stargazers',
                  value: projectStarsLabel(details.project.stargazersCount),
                ),
                const SizedBox(height: AppSpacing.lg),
                _StatsRow(label: 'Last Sync', value: pushedAtText),
                const SizedBox(height: AppSpacing.lg),
                ProjectActivityPulse(
                  activity: details.commitActivity,
                  isLoading: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          label,
          style: context.textStyles.titleMedium?.withColor(
            colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: context.textStyles.titleLarge?.semiBold.withColor(
            colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
