class IndikatorImageMapper {
  static String getImage(String slug) {
    switch (slug) {
      case 'geografi':
        return 'assets/images/geografi.png';
      case 'kependudukan':
        return 'assets/images/kependudukan.png';
      case 'ketenagakerjaan':
        return 'assets/images/ketenagakerjaan.png';
      case 'pendidikan':
        return 'assets/images/pendidikan.png';
      case 'indeks-pembangunan-manusia':
        return 'assets/images/indeks-pembangunan-manusia.png';  // contoh penyesuaian
      case 'pdrb':
        return 'assets/images/pdrb.png';
      case 'kemiskinan':
        return 'assets/images/kemiskinan.png';
      case 'indeks-kemahalan-kontruksi':
        return 'assets/images/indeks-kemahalan-konstruksi.png';
      case 'ketimpangan-gender':
        return 'assets/images/ketimpangan-gender.png';
      case 'produksi-tanaman-pangan':
        return 'assets/images/produksi-tanaman-pangan.png';
      case 'sanitasi-dan-air':
        return 'assets/images/sanitasi-dan-air.png';
      case 'industri-pengolahan-mikro-kecil':
        return 'assets/images/industri-pengolahan-mikrokecil.png';
       default:
        return 'assets/images/default.png';
    }
  }
}
