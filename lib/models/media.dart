class Media {
  final String url;
  final MediaFormats? formats;

  Media({required this.url, this.formats});

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    url: json['url'] as String? ?? '',
    formats: json['formats'] != null
        ? MediaFormats.fromJson(json['formats'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {'url': url, 'formats': formats?.toJson()};

  String getFullUrl(String baseUrl) {
    if (url.startsWith('http')) return url;
    return '$baseUrl$url';
  }

  String? getThumbnailUrl(String baseUrl) {
    if (formats?.thumbnail != null) {
      final thumbUrl = formats!.thumbnail!;
      if (thumbUrl.startsWith('http')) return thumbUrl;
      return '$baseUrl$thumbUrl';
    }
    return getFullUrl(baseUrl);
  }

  String? getMediumUrl(String baseUrl) {
    if (formats?.medium != null) {
      final medUrl = formats!.medium!;
      if (medUrl.startsWith('http')) return medUrl;
      return '$baseUrl$medUrl';
    }
    return getFullUrl(baseUrl);
  }
}

class MediaFormats {
  final String? small;
  final String? medium;
  final String? thumbnail;

  MediaFormats({this.small, this.medium, this.thumbnail});

  factory MediaFormats.fromJson(Map<String, dynamic> json) => MediaFormats(
    small: json['small'] != null ? json['small']['url'] as String? : null,
    medium: json['medium'] != null ? json['medium']['url'] as String? : null,
    thumbnail: json['thumbnail'] != null
        ? json['thumbnail']['url'] as String?
        : null,
  );

  Map<String, dynamic> toJson() => {
    'small': small,
    'medium': medium,
    'thumbnail': thumbnail,
  };
}
