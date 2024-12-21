// To parse this JSON data, do
//
//     final reply = replyFromJson(jsonString);

import 'dart:convert';

List<Reply> replyFromJson(String str) =>
    List<Reply>.from(json.decode(str).map((x) => Reply.fromJson(x)));

String replyToJson(List<Reply> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reply {
  Model model;
  int pk;
  Fields fields;

  Reply({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
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
  String discussion;
  int sender;
  DateTime replied;
  String message;

  Fields({
    required this.discussion,
    required this.sender,
    required this.replied,
    required this.message,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        discussion: json["discussion"],
        sender: json["sender"],
        replied: DateTime.parse(json["replied"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "discussion": discussion,
        "sender": sender,
        "replied": replied.toIso8601String(),
        "message": message,
      };
}

enum Model { USER_FORUM_REPLY }

final modelValues = EnumValues({"UserForum.reply": Model.USER_FORUM_REPLY});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
