import 'dart:convert';

class Artist {
  final String name;
  final String url;
  Artist({
    required this.name,
    required this.url,
  });

  Artist copyWith({
    String? name,
    String? url,
  }) {
    return Artist(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Artist(name: $name, url: $url)';

  @override
  bool operator ==(covariant Artist other) {
    if (identical(this, other)) return true;

    return other.name == name && other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
