// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

List<UserData> userDataFromJson(String str) => List<UserData>.from(json.decode(str).map((x) => UserData.fromJson(x)));

String userDataToJson(List<UserData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserData {
    String model;
    int pk;
    Fields fields;

    UserData({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
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
    String profileName;
    String username;
    String profilePicture;
    String about;
    String location;
    String phone;
    String email;
    String password;
    List<dynamic> favoritePhones;

  var name;

    Fields({
        required this.user,
        required this.profileName,
        required this.username,
        required this.profilePicture,
        required this.about,
        required this.location,
        required this.phone,
        required this.email,
        required this.password,
        required this.favoritePhones,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        profileName: json["profile_name"],
        username: json["username"],
        profilePicture: json["profile_picture"],
        about: json["about"],
        location: json["location"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        favoritePhones: List<dynamic>.from(json["favorite_phones"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "profile_name": profileName,
        "username": username,
        "profile_picture": profilePicture,
        "about": about,
        "location": location,
        "phone": phone,
        "email": email,
        "password": password,
        "favorite_phones": List<dynamic>.from(favoritePhones.map((x) => x)),
    };
}
