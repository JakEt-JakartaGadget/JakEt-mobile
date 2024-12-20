// lib/app_module/data/model/product_entry.dart

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) =>
    List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
  String model;
  String pk;
  Fields fields;

  ProductEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: json["model"] ?? '',
        pk: json["pk"] ?? '',
        fields: Fields.fromJson(json["fields"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String brand;
  String model;
  String storage;
  String ram;
  double screenSizeInches;
  String cameraMp;
  int batteryCapacityMah;
  double priceUsd;
  double? priceInr;
  double rating;
  String imageUrl;
  int oneStar;
  int twoStar;
  int threeStar;
  int fourStar;
  int fiveStar;

  Fields({
    required this.brand,
    required this.model,
    required this.storage,
    required this.ram,
    required this.screenSizeInches,
    required this.cameraMp,
    required this.batteryCapacityMah,
    required this.priceUsd,
    required this.priceInr,
    required this.rating,
    required this.imageUrl,
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        brand: json["brand"] ?? '',
        model: json["model"] ?? '',
        storage: json["storage"] ?? '',
        ram: json["ram"] ?? '',
        screenSizeInches: (json["screen_size_inches"] as num?)?.toDouble() ?? 0.0,
        cameraMp: json["camera_mp"] ?? '',
        batteryCapacityMah: json["battery_capacity_mAh"] ?? 0,
        priceUsd: _parseDouble(json["price_usd"]),
        priceInr: json["price_inr"] != null ? _parseDouble(json["price_inr"]) : null,
        rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
        imageUrl: json["image_url"] ?? '',
        oneStar: json["one_star"] ?? 0,
        twoStar: json["two_star"] ?? 0,
        threeStar: json["three_star"] ?? 0,
        fourStar: json["four_star"] ?? 0,
        fiveStar: json["five_star"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "model": model,
        "storage": storage,
        "ram": ram,
        "screen_size_inches": screenSizeInches,
        "camera_mp": cameraMp,
        "battery_capacity_mAh": batteryCapacityMah,
        "price_usd": priceUsd,
        "price_inr": priceInr,
        "rating": rating,
        "image_url": imageUrl,
        "one_star": oneStar,
        "two_star": twoStar,
        "three_star": threeStar,
        "four_star": fourStar,
        "five_star": fiveStar,
      };

  // Helper method to parse double values from dynamic input
  static double _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }
}
