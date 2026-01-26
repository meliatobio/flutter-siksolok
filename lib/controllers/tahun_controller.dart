import 'package:get/get.dart';

class TahunController extends GetxController {
  final tahun = DateTime.now().year.obs;

  void setTahun(int value) {
    tahun.value = value;
  }
}
