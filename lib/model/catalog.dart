import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'artist.dart';

class Catalog {
  final String title;
  final String url;
  final List<Artist> artist;
  Catalog({
    required this.title,
    required this.url,
    required this.artist,
  });

  Catalog copyWith({
    String? title,
    String? url,
    List<Artist>? artist,
  }) {
    return Catalog(
      title: title ?? this.title,
      url: url ?? this.url,
      artist: artist ?? this.artist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
      'artist': artist.map((x) => x.toMap()).toList(),
    };
  }

  factory Catalog.fromMap(Map<String, dynamic> map) {
    return Catalog(
      title: map['title'] as String,
      url: map['url'] as String,
      artist: List<Artist>.from(
        (map['artist'] as List).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Catalog.fromJson(String source) =>
      Catalog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Catalog(title: $title, url: $url, artist: $artist)';

  @override
  bool operator ==(covariant Catalog other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.url == url &&
        listEquals(other.artist, artist);
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode ^ artist.hashCode;
}
