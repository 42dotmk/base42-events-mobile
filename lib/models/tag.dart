class Tag {
  final int id;
  final String tagName;

  Tag({required this.id, required this.tagName});

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json['id'] as int, tagName: json['tagName'] as String? ?? '');

  Map<String, dynamic> toJson() => {'id': id, 'tagName': tagName};
}
