import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jaket_mobile/presentation/homepage/homepage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/auth_controller.dart';

void main() {
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: GetMaterialApp(
        title: 'JakEt',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
