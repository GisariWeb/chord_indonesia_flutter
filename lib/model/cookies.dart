import 'dart:convert';

class Cookies {
  final String? appVersion;
  final int lastFetchCatalog;
  Cookies({
    this.appVersion,
    required this.lastFetchCatalog,
  });

  Cookies copyWith({
    String? appVersion,
    int? lastFetchCatalog,
  }) {
    return Cookies(
      appVersion: appVersion ?? this.appVersion,
      lastFetchCatalog: lastFetchCatalog ?? this.lastFetchCatalog,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appVersion': appVersion,
      'lastFetchCatalog': lastFetchCatalog,
    };
  }

  factory Cookies.fromMap(Map<String, dynamic> map) {
    return Cookies(
      appVersion: map['appVersion'],
      lastFetchCatalog: map['lastFetchCatalog'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cookies.fromJson(String source) =>
      Cookies.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Cookies(appVersion: $appVersion, lastFetchCatalog: $lastFetchCatalog)';

  @override
  bool operator ==(covariant Cookies other) {
    if (identical(this, other)) return true;

    return other.appVersion == appVersion &&
        other.lastFetchCatalog == lastFetchCatalog;
  }

  @override
  int get hashCode => appVersion.hashCode ^ lastFetchCatalog.hashCode;
}
