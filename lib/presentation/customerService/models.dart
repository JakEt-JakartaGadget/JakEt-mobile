// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  List<DailyCustomerService> dailyCustomerServices;
  List<Chat> chats;

  Product({
    required this.dailyCustomerServices,
    required this.chats,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        dailyCustomerServices: List<DailyCustomerService>.from(
            json["dailyCustomerServices"]
                .map((x) => DailyCustomerService.fromJson(x))),
        chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dailyCustomerServices":
            List<dynamic>.from(dailyCustomerServices.map((x) => x.toJson())),
        "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
      };
}

class Chat {
  Model model;
  int pk;
  ChatFields fields;

  Chat({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: ChatFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class ChatFields {
  int user;
  DateTime date;
  String message;
  String timeSent;
  bool read;
  bool sentByUser;

  ChatFields({
    required this.user,
    required this.date,
    required this.message,
    required this.timeSent,
    required this.read,
    required this.sentByUser,
  });

  factory ChatFields.fromJson(Map<String, dynamic> json) => ChatFields(
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

enum Model { CUSTOMER_SERVICE_CHAT }

final modelValues =
    EnumValues({"CustomerService.chat": Model.CUSTOMER_SERVICE_CHAT});

class DailyCustomerService {
  String model;
  int pk;
  DailyCustomerServiceFields fields;

  DailyCustomerService({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory DailyCustomerService.fromJson(Map<String, dynamic> json) =>
      DailyCustomerService(
        model: json["model"],
        pk: json["pk"],
        fields: DailyCustomerServiceFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class DailyCustomerServiceFields {
  int user;
  DateTime date;

  DailyCustomerServiceFields({
    required this.user,
    required this.date,
  });

  factory DailyCustomerServiceFields.fromJson(Map<String, dynamic> json) =>
      DailyCustomerServiceFields(
        user: json["user"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
