class ProjectRepo {
  final String ownerLogin;
  final String name;
  final String description;
  final String htmlUrl;
  final String language;
  final int stargazersCount;
  final DateTime? pushedAt;
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
    required this.fork,
    required this.archived,
  });

  factory ProjectRepo.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>?;

    return ProjectRepo(
      ownerLogin: owner?['login'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      language: json['language'] as String? ?? 'Unknown',
      stargazersCount: json['stargazers_count'] as int? ?? 0,
      pushedAt: DateTime.tryParse(json['pushed_at'] as String? ?? ''),
      fork: json['fork'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
    );
  }
}
