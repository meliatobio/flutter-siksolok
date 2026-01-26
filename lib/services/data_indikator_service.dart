import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/config.dart';
import '../models/data_indikator.dart';

class DataIndikatorService {
  static Future<List<DataIndikator>> getDataIndikator({
    required int indikatorId,
    required int tahun,
  }) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/data-indikator/$indikatorId?tahun=$tahun',
    );

    debugPrint('➡️ REQUEST: $url');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['data'] ?? [];
      return data.map((e) => DataIndikator.fromJson(e)).toList();
    } else {
      throw Exception('Gagal fetch data indikator');
    }
  }
}
