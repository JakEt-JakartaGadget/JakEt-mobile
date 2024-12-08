// lib/models/device.dart

class Device {
  final String model;
  final String brand;
  final String productName;
  final String pictureUrl;
  final int batteryCapacity;
  final String priceInIdr;
  final String ram;
  final String camera;
  final String processor;
  final String screenSize;
  final String url;

  Device({
    required this.model,
    required this.brand,
    required this.productName,
    required this.pictureUrl,
    required this.batteryCapacity,
    required this.priceInIdr,
    required this.ram,
    required this.camera,
    required this.processor,
    required this.screenSize,
    required this.url,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      model: json['model'],
      brand: json['brand'],
      productName: json['product_name'],
      pictureUrl: json['picture_url'],
      batteryCapacity: json['battery_capacity_mAh'],
      priceInIdr: json['price_inr'],  
      ram: json['ram'],
      camera: json['camera'],
      processor: json['processor'],
      screenSize: json['screen_size'],
      url: json['url'],
    );
  }
}
