import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/app/routers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indikator Strategis Kabupaten Solok 2024',

      theme: ThemeData(
        primaryColor: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),

      // 👉 ARAHKAN KE SPLASHSCREEN
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
