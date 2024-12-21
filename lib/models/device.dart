// device.dart
import 'dart:convert';

List<Comparison> comparisonFromJson(String str) => List<Comparison>.from(json.decode(str).map((x) => Comparison.fromJson(x)));

String comparisonToJson(List<Comparison> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comparison {
  String model;
  String brand;
  String productName;
  String pictureUrl;
  String batteryCapacityMAh;
  String priceInr;
  String priceIdr;
  String ram;
  String camera;
  String processor;
  String screenSize;
  String url;

  Comparison({
    required this.model,
    required this.brand,
    required this.productName,
    required this.pictureUrl,
    required this.batteryCapacityMAh,
    required this.priceInr,
    required this.priceIdr,
    required this.ram,
    required this.camera,
    required this.processor,
    required this.screenSize,
    required this.url,
  });

  factory Comparison.fromJson(Map<String, dynamic> json) {
    String pictureUrl = json["picture_url"];
    pictureUrl = pictureUrl.replaceAll('&amp;', '&');
    return Comparison(
      model: json["model"] ?? "",
      brand: json["brand"] ?? "",
      productName: json["product_name"] ?? "",
      pictureUrl: pictureUrl,
      batteryCapacityMAh: json["battery_capacity_mAh"] ?? "",
      priceInr: json["price_inr"] ?? "",
      priceIdr: json["price_idr"] ?? "",
      ram: json["ram"] ?? "",
      camera: json["camera"] ?? "",
      processor: json["processor"] ?? "",
      screenSize: json["screen_size"] ?? "",
      url: json["url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "model": model,
        "brand": brand,
        "product_name": productName,
        "picture_url": pictureUrl,
        "battery_capacity_mAh": batteryCapacityMAh,
        "price_inr": priceInr,
        "price_idr": priceIdr,
        "ram": ram,
        "camera": camera,
        "processor": processor,
        "screen_size": screenSize,
        "url": url,
      };
}
