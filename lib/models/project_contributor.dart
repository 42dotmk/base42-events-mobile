class ProjectContributor {
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final int contributions;

  const ProjectContributor({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.contributions,
  });

  factory ProjectContributor.fromJson(Map<String, dynamic> json) {
    return ProjectContributor(
      login: json['login'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      contributions: json['contributions'] as int? ?? 0,
    );
  }
}
