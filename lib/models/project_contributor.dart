class ProjectContributor {
  final String login;
  final String avatarUrl;

  const ProjectContributor({required this.login, required this.avatarUrl});

  factory ProjectContributor.fromJson(Map<String, dynamic> json) {
    return ProjectContributor(
      login: json['login'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
    );
  }
}
