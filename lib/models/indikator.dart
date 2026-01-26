class Indikator {
  final int id;
  final String namaIndikator;
  final String slug;

  Indikator({
    required this.id,
    required this.namaIndikator,
    required this.slug,
  });

  factory Indikator.fromJson(Map<String, dynamic> json) {
    return Indikator(
      id: json['id'],
      namaIndikator: json['nama_indikator'],
      slug: json['slug'],
    );
  }
}
