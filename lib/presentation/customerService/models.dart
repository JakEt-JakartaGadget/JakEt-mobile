// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

List<Chat> chatFromJson(String str) =>
    List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chat {
  String model;
  int pk;
  Fields fields;

  Chat({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  DateTime date;
  String message;
  String timeSent;
  bool read;
  bool sentByUser;

  Fields({
    required this.user,
    required this.date,
    required this.message,
    required this.timeSent,
    required this.read,
    required this.sentByUser,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        date: DateTime.parse(json["date"]),
        message: json["message"],
        timeSent: json["time_sent"],
        read: json["read"],
        sentByUser: json["sent_by_user"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "message": message,
        "time_sent": timeSent,
        "read": read,
        "sent_by_user": sentByUser,
      };
}
