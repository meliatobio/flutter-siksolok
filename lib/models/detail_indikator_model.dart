import 'kategori_model.dart';

class IndikatorDetail {
  final int id;
  final String namaIndikator;
  final String slug;
  final String deskripsi;
  final List<KategoriModel> kategoris;

  IndikatorDetail({
    required this.id,
    required this.namaIndikator,
    required this.slug,
    required this.deskripsi,
    required this.kategoris,
  });
  factory IndikatorDetail.fromJson(Map<String, dynamic> json) {
    return IndikatorDetail(
      id: json['id'] ?? 0,
      namaIndikator: json['nama_indikator'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kategoris: json['kategoris'] is List
          ? json['kategoris']
                .map<KategoriModel>((e) => KategoriModel.fromJson(e))
                .toList()
          : [],
    );
  }

  // factory IndikatorDetail.fromJson(Map<String, dynamic> json) {
  //   return IndikatorDetail(
  //     id: json['id'],
  //     namaIndikator: json['nama_indikator'],
  //     slug: json['slug'],
  //     deskripsi: json['deskripsi'],
  //     kategoris: (json['kategoris'] as List)
  //         .map((e) => KategoriModel.fromJson(e))
  //         .toList(),
  //   );
  // }
}
