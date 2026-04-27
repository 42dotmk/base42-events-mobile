class ProjectCommitWeek {
  final int week;
  final int total;
  final List<int> days;

  const ProjectCommitWeek({
    required this.week,
    required this.total,
    required this.days,
  });

  factory ProjectCommitWeek.fromJson(Map<String, dynamic> json) {
    final daysData = json['days'];
    return ProjectCommitWeek(
      week: json['week'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      days: daysData is List
          ? daysData.map((d) => d is int ? d : 0).toList()
          : <int>[],
    );
  }
}
