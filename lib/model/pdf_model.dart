import 'dart:convert';

class PdfModel {
  final String title;
  final String url;
  PdfModel({
    required this.title,
    required this.url,
  });

  PdfModel copyWith({
    String? title,
    String? url,
  }) {
    return PdfModel(
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'url': url});

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
  String toString() => 'PdfModel(title: $title, url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PdfModel && other.title == title && other.url == url;
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}
