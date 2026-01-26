import 'package:siksolok/models/data_indikator.dart';

class IndikatorModel {
  final int id;
  final String namaIndikator;
  final String slug;
  final List<DataIndikator> dataIndikators;

  IndikatorModel({
    required this.id,
    required this.namaIndikator,
    required this.slug,
    required this.dataIndikators,
  });

  factory IndikatorModel.fromJson(Map<String, dynamic> json) {
    return IndikatorModel(
      id: json['id'],
      namaIndikator: json['nama_indikator'],
      slug: json['slug'],
      dataIndikators: json['data_indikators'] != null
          ? List<DataIndikator>.from(
              json['data_indikators']
                  .map((x) => DataIndikator.fromJson(x)),
            )
          : [],
    );
  }
}
