import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../models/indikator_model.dart';

class DashboardService {
  static Future<List<IndikatorModel>> fetchDashboard(int tahun) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/dashboard?tahun=$tahun'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data dashboard');
    }

    final json = jsonDecode(response.body);

    return List<IndikatorModel>.from(
      json['data'].map((x) => IndikatorModel.fromJson(x)),
    );
  }
}
