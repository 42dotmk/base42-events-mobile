import 'package:base42_events_mobile/models/media.dart';
import 'package:base42_events_mobile/models/tag.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final String summary;
  final String slug;
  final DateTime start;
  final String locale;
  final String? registerLink;
  final String? calendarUrl;
  final Media? promo;
  final List<Media>? photos;
  final List<Tag> tags;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.summary,
    required this.slug,
    required this.start,
    required this.locale,
    this.registerLink,
    this.calendarUrl,
    this.promo,
    this.photos,
    required this.tags,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      start: DateTime.parse(json['start'] as String),
      locale: json['locale'] as String? ?? 'en',
      registerLink: json['registerLink'] as String?,
      calendarUrl: json['calendarUrl'] as String?,
      promo: json['promo'] != null
          ? Media.fromJson(json['promo'] as Map<String, dynamic>)
          : null,
      photos: json['photos'] != null
          ? (json['photos'] as List)
                .map((p) => Media.fromJson(p as Map<String, dynamic>))
                .toList()
          : null,
      tags: json['tags'] != null
          ? (json['tags'] as List)
                .map((t) => Tag.fromJson(t as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'summary': summary,
    'slug': slug,
    'start': start.toIso8601String(),
    'locale': locale,
    'registerLink': registerLink,
    'calendarUrl': calendarUrl,
    'promo': promo?.toJson(),
    'photos': photos?.map((p) => p.toJson()).toList(),
    'tags': tags.map((t) => t.toJson()).toList(),
  };
}
