import 'dart:convert';

class PdfModel {
  String title;
  String url;
  String? path;
  PdfModel({
    required this.title,
    required this.url,
    this.path,
  });

  PdfModel copyWith({
    String? title,
    String? url,
    String? path,
  }) {
    return PdfModel(
      title: title ?? this.title,
      url: url ?? this.url,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'url': url});
    if (path != null) {
      result.addAll({'path': path});
    }

    return result;
  }

  factory PdfModel.fromMap(dynamic map) {
    return PdfModel(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PdfModel.fromJson(String source) =>
      PdfModel.fromMap(json.decode(source));

  @override
  String toString() => 'PdfModel(title: $title, url: $url, path: $path)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PdfModel &&
        other.title == title &&
        other.url == url &&
        other.path == path;
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode ^ path.hashCode;
}
