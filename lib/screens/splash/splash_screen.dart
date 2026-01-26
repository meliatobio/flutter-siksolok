import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/app/routers.dart';
import 'package:siksolok/widgets/wave_clipper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(AppRoutes.main);
      });
    });
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// KIRI ATAS
          ClipPath(
            clipper: SplashWaveClipper(),
            child: Container(
              height: size.height * 0.25,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF9A825),
                    Color(0xFF43A047),
                    Color(0xFF1E88E5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          /// KANAN BAWAH (mirror)
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: 3.1416, // 180 derajat
              child: ClipPath(
                clipper: SplashWaveClipper(),
                child: Container(
                  height: size.height * 0.25,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFF9A825),
                        Color(0xFF43A047),
                        Color(0xFF1E88E5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// KONTEN TENGAH
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo_bps.png',
                  width: size.width * 0.35,
                ),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    children: const [
                      TextSpan(
                        text: 'Indikator Strategis\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // bold
                        ),
                      ),
                      TextSpan(
                        text: 'Kabupaten Solok', // normal
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
