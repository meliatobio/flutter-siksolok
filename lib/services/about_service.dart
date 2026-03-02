import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siksolok/models/about_model.dart';

class AboutService {
  static const String baseUrl = 'http://192.168.3.220:8000/api';

  /// 🔹 GET ALL ABOUTS
static Future<List<About>> fetchAbouts() async {
  final response = await http.get(Uri.parse('$baseUrl/abouts'));

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);

    if (decoded is List) {
      return decoded.map((e) => About.fromJson(e)).toList();
    } else if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      return (data as List)
          .map((e) => About.fromJson(e))
          .toList();
    } else {
      throw Exception('Format data tidak dikenali');
    }
  } else {
    throw Exception('Gagal memuat data about');
  }
}


  /// 🔹 GET ABOUT BY ID (optional, tetap dipakai kalau perlu)
  static Future<About> getAboutById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/abouts/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return About.fromJson(jsonData['data']);
    } else {
      throw Exception('Gagal load about');
    }
  }
}
