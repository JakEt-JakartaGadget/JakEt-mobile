// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  List<Discussion> discussions;
  List<Reply> replies;

  Product({
    required this.discussions,
    required this.replies,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        discussions: List<Discussion>.from(
            json["discussions"].map((x) => Discussion.fromJson(x))),
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "discussions": List<dynamic>.from(discussions.map((x) => x.toJson())),
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class Discussion {
  String model;
  String pk;
  DiscussionFields fields;

  Discussion({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
        model: json["model"],
        pk: json["pk"],
        fields: DiscussionFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class DiscussionFields {
  int owner;
  DateTime started;
  String topic;

  DiscussionFields({
    required this.owner,
    required this.started,
    required this.topic,
  });

  factory DiscussionFields.fromJson(Map<String, dynamic> json) =>
      DiscussionFields(
        owner: json["owner"],
        started: DateTime.parse(json["started"]),
        topic: json["topic"],
      );

  Map<String, dynamic> toJson() => {
        "owner": owner,
        "started": started.toIso8601String(),
        "topic": topic,
      };
}

class Reply {
  Model model;
  int pk;
  ReplyFields fields;

  Reply({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: ReplyFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class ReplyFields {
  String discussion;
  int sender;
  DateTime replied;
  String message;

  ReplyFields({
    required this.discussion,
    required this.sender,
    required this.replied,
    required this.message,
  });

  factory ReplyFields.fromJson(Map<String, dynamic> json) => ReplyFields(
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
