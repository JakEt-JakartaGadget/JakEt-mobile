// To parse this JSON data, do
//
//     final serviceCenter = serviceCenterFromJson(jsonString);

import 'dart:convert';

List<ServiceCenter> serviceCenterFromJson(String str) => List<ServiceCenter>.from(json.decode(str).map((x) => ServiceCenter.fromJson(x)));

String serviceCenterToJson(List<ServiceCenter> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceCenter {
    String model;
    String pk;
    Fields fields;

    ServiceCenter({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ServiceCenter.fromJson(Map<String, dynamic> json) => ServiceCenter(
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
    dynamic user;
    String image;
    String name;
    String address;
    String contact;
    String rating;
    int totalReviews;

    Fields({
        required this.user,
        required this.image,
        required this.name,
        required this.address,
        required this.contact,
        required this.rating,
        required this.totalReviews,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        image: json["image"],
        name: json["name"],
        address: json["address"],
        contact: json["contact"],
        rating: json["rating"],
        totalReviews: json["total_reviews"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "image": image,
        "name": name,
        "address": address,
        "contact": contact,
        "rating": rating,
        "total_reviews": totalReviews,
    };
}
