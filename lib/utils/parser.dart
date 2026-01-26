String parseKategoriDeskripsi(dynamic deskripsi, int tahun) {
  if (deskripsi == null) return '-';

  // Kalau STRING → tampilkan langsung
  if (deskripsi is String) {
    return _cleanHtml(deskripsi);
  }

  // Kalau MAP → ambil berdasarkan tahun
  if (deskripsi is Map<String, dynamic>) {
    final value = deskripsi[tahun.toString()];
    if (value == null) return '-';
    return _cleanHtml(value.toString());
  }

  return '-';
}

String _cleanHtml(String html) {
  // buang tag HTML
  return html
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .trim();
}
