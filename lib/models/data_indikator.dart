class DataIndikator {
  final int id;
  final String deskripsi;
  final int tahun;
  final int kategoriId;

  DataIndikator({
    required this.id,
    required this.deskripsi,
    required this.tahun,
    required this.kategoriId,
  });

  factory DataIndikator.fromJson(Map<String, dynamic> json) {
    return DataIndikator(
      id: json['id'],
      deskripsi: json['deskripsi'] ?? '',
      tahun: int.parse(json['tahun'].toString()),
      kategoriId: json['kategori_id'],
    );
  }
}
