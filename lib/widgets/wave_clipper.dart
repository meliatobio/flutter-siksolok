import 'package:flutter/material.dart';

class SplashWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Mulai kiri atas
    path.moveTo(9, 0);
    path.lineTo(20, size.height * 0.100);

    // Kurva S kiri
    path.cubicTo(
      size.width * 0.100,
      size.height * 0.20,
      size.width * 0.25,
      size.height * 0.55,
      size.width * 0.45,
      size.height * 0.56,
    );

    // Kurva S tengah
    path.cubicTo(
      size.width * 0.65,
      size.height * 0.55,
      size.width * 0.60,
      size.height * 0.75,
      size.width * 0.80,
      size.height * 0.85,
    );

    // Masuk ke kanan bawah
    path.lineTo(size.width, size.height * 0.90);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
