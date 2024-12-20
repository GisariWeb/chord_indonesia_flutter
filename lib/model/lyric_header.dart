import 'dart:convert';

class LyricHeader {
  final String title;
  final String url;
  LyricHeader({
    required this.title,
    required this.url,
  });

  LyricHeader copyWith({
    String? title,
    String? url,
  }) {
    return LyricHeader(
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
    };
  }

  factory LyricHeader.fromMap(Map<String, dynamic> map) {
    return LyricHeader(
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LyricHeader.fromJson(String source) =>
      LyricHeader.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LyricHeader(title: $title, url: $url)';

  @override
  bool operator ==(covariant LyricHeader other) {
    if (identical(this, other)) return true;

    return other.title == title && other.url == url;
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}
