// To parse this JSON data, do
//
//     final discussionModel = discussionModelFromJson(jsonString);

import 'dart:convert';

List<DiscussionModel> discussionModelFromJson(String str) =>
    List<DiscussionModel>.from(
        json.decode(str).map((x) => DiscussionModel.fromJson(x)));

String discussionModelToJson(List<DiscussionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscussionModel {
  String model;
  String pk;
  Fields fields;

  DiscussionModel({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory DiscussionModel.fromJson(Map<String, dynamic> json) =>
      DiscussionModel(
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
  int owner;
  DateTime started;
  String topic;

  Fields({
    required this.owner,
    required this.started,
    required this.topic,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
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
