// To parse this JSON data, do
//
//     final tiket = tiketFromJson(jsonString);

import 'dart:convert';

List<Tiket> tiketFromJson(String str) => List<Tiket>.from(json.decode(str).map((x) => Tiket.fromJson(x)));

String tiketToJson(List<Tiket> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tiket {
    String id;
    DateTime serviceDate;
    String serviceTime;
    String specificProblems;
    ServiceCenterDetails serviceCenter;

    Tiket({
        required this.id,
        required this.serviceDate,
        required this.serviceTime,
        required this.specificProblems,
        required this.serviceCenter,
    });

    factory Tiket.fromJson(Map<String, dynamic> json) => Tiket(
        id: json["id"],
        serviceDate: DateTime.parse(json["service_date"]),
        serviceTime: json["service_time"],
        specificProblems: json["specific_problems"],
        serviceCenter: ServiceCenterDetails.fromJson(json["service_center"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_date": "${serviceDate.year.toString().padLeft(4, '0')}-${serviceDate.month.toString().padLeft(2, '0')}-${serviceDate.day.toString().padLeft(2, '0')}",
        "service_time": serviceTime,
        "specific_problems": specificProblems,
        "service_center": serviceCenter.toJson(),
    };
}

class ServiceCenterDetails {
    String name;
    String address;
    String contact;

    ServiceCenterDetails({
        required this.name,
        required this.address,
        required this.contact,
    });

    factory ServiceCenterDetails.fromJson(Map<String, dynamic> json) => ServiceCenterDetails(
        name: json["name"],
        address: json["address"],
        contact: json["contact"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "contact": contact,
    };
}
