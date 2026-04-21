class ProjectCommitWeek {
  final int week;
  final int total;

  const ProjectCommitWeek({required this.week, required this.total});

  factory ProjectCommitWeek.fromJson(Map<String, dynamic> json) {
    return ProjectCommitWeek(
      week: json['week'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}
