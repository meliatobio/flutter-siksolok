import 'package:get/get.dart';
import 'package:siksolok/app/main_page.dart';
import 'package:siksolok/screens/indikator/indikator_detail_screen.dart';
import 'package:siksolok/screens/splash/splash_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const main = '/main';
  static const indikatorDetail = '/indikator-detail';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: main, page: () => MainPage()),
    GetPage(name: indikatorDetail, page: () => const IndikatorDetailScreen()),
  ];
}