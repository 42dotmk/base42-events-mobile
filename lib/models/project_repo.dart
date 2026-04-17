class ProjectRepo {
  final String name;
  final String description;
  final String htmlUrl;
  final String language;
  final DateTime? pushedAt;
  final bool fork;
  final bool archived;

  const ProjectRepo({
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.language,
    required this.pushedAt,
    required this.fork,
    required this.archived,
  });

  factory ProjectRepo.fromJson(Map<String, dynamic> json) {
    return ProjectRepo(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      language: json['language'] as String? ?? 'Unknown',
      pushedAt: DateTime.tryParse(json['pushed_at'] as String? ?? ''),
      fork: json['fork'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
    );
  }
}
