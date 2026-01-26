import 'package:get/get.dart';
import '../models/data_indikator.dart';

class IndikatorController extends GetxController {
  var data = <DataIndikator>[].obs;
  var selectedYear = 2024.obs;

  void setData(List<DataIndikator> newData) {
    data.value = newData;
  }
}
