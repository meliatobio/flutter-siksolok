class KategoriModel {
  final int id;
  final String namaKategori;
  final String deskripsi;
  final int tahun;
  final String? gambar;

  KategoriModel({
    required this.id,
    required this.namaKategori,
    required this.deskripsi,
    required this.tahun,
    this.gambar,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'],
      namaKategori: json['nama_kategori'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tahun: json['tahun'] ?? 0,
      gambar: json['gambar'], // URL FULL dari backend
    );
  }
}
