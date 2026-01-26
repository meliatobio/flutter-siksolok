import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/config.dart';
import '../models/kategori_model.dart';

class KategoriService {
  static Future<List<KategoriModel>> getKategoriByIndikator(
    int indikatorId,
    int tahun,
) async {
  final response = await http.get(
    Uri.parse(
      '${AppConfig.baseUrl}/indikator/$indikatorId/kategori?tahun=$tahun',
    ),
    headers: {
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List data = json['data'];

    return data.map((e) => KategoriModel.fromJson(e)).toList();
  } else {
    throw Exception('Gagal memuat kategori');
  }
}

}
