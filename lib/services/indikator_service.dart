import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:siksolok/models/indikator.dart';
import 'package:siksolok/models/detail_indikator_model.dart';

class IndikatorService {
  static const String baseUrl = 'http://localhost:8000/api';

  /// =============================
  /// GET LIST INDIKATOR (TOPIK)
  /// =============================
  static Future<List<Indikator>> fetchIndikators() async {
    final url = Uri.parse('$baseUrl/indikators');
    debugPrint('➡️ [INDIKATOR LIST] REQUEST: $url');

    try {
      final response = await http.get(url);

      debugPrint('⬅️ STATUS: ${response.statusCode}');
      debugPrint('⬅️ BODY: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List list = jsonData['data'];

        return list.map((e) => Indikator.fromJson(e)).toList();
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ ERROR fetchIndikators: $e');
      throw Exception('Gagal memuat indikator');
    }
  }

  /// ===================================
  /// GET DETAIL INDIKATOR + KATEGORI
  /// BERDASARKAN TAHUN (🔥 PENTING)
  /// ===================================
  static Future<IndikatorDetail> fetchIndikatorDetail(
    String slug,
    int tahun,
  ) async {
    final url = Uri.parse('$baseUrl/indikators/$slug?tahun=$tahun');

    debugPrint('➡️ [INDIKATOR DETAIL] REQUEST: $url');

    try {
      final response = await http.get(url);

      debugPrint('⬅️ STATUS: ${response.statusCode}');
      debugPrint('⬅️ BODY: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return IndikatorDetail.fromJson(jsonData['data']);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ ERROR fetchIndikatorDetail: $e');
      throw Exception('Gagal memuat detail indikator');
    }
  }

  static Future<List<Indikator>> searchIndikator(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/indikator/search?q=$query'),
    );
    final data = jsonDecode(response.body);
    return data.map<Indikator>((e) => Indikator.fromJson(e)).toList();
  }
}
