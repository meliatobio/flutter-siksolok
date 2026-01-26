import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/controllers/bottom_nav_controller.dart';
import 'package:siksolok/controllers/tahun_controller.dart';
import 'package:siksolok/screens/about/about_screen.dart';
import 'package:siksolok/screens/home/home_screen.dart';
import 'package:siksolok/screens/indikator/indikator_screen.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  // ✅ REGISTER CONTROLLER SEKALI
  final BottomNavController bottomNavController = Get.put(
    BottomNavController(),
  );

  final TahunController tahunController = Get.put(
    TahunController(),
    permanent: true,
  );

  // ❌ JANGAN PAKAI const DI SINI
  final List<Widget> pages = [HomeScreen(), IndikatorScreen(), AboutScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: bottomNavController.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNavController.selectedIndex.value,
          onTap: bottomNavController.changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2D95C9),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Indikator',
            ),

            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          ],
        ),
      ),
    );
  }
}
