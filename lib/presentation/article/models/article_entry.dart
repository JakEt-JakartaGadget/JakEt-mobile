// To parse this JSON data, do
//
//     final artikel = artikelFromJson(jsonString);

import 'dart:convert';

List<Artikel> artikelFromJson(String str) => List<Artikel>.from(json.decode(str).map((x) => Artikel.fromJson(x)));

String artikelToJson(List<Artikel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Artikel {
    Model model;
    int pk;
    Fields fields;

    Artikel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Artikel.fromJson(Map<String, dynamic> json) => Artikel(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String content;
    String imageUrl;
    String source;
    DateTime publishedDate;

    Fields({
        required this.title,
        required this.content,
        required this.imageUrl,
        required this.source,
        required this.publishedDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        content: json["content"],
        imageUrl: json["image_url"],
        source: json["source"],
        publishedDate: DateTime.parse(json["published_date"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "image_url": imageUrl,
        "source": source,
        "published_date": publishedDate.toIso8601String(),
    };
}

enum Model {
    ARTICLE_ARTIKEL
}

final modelValues = EnumValues({
    "Article.artikel": Model.ARTICLE_ARTIKEL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
