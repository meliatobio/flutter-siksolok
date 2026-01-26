import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:siksolok/controllers/bottom_nav_controller.dart';
import 'package:siksolok/controllers/tahun_controller.dart';
import 'package:siksolok/models/detail_indikator_model.dart';
import 'package:siksolok/models/indikator_model.dart';
import 'package:siksolok/screens/home/search_screen.dart';
import 'package:siksolok/screens/indikator/indikator_detail_screen.dart';
import 'package:siksolok/services/dashboard_service.dart';
//import 'package:siksolok/widgets/build_stat_card.dart';
import 'package:siksolok/services/indikator_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> notifications = [];
  final ScrollController indikatorScrollController = ScrollController();

  late TahunController tahunController;
  int selectedYear = DateTime.now().year;
  late Future<List<IndikatorModel>> dashboardFuture;
  List<IndikatorDetail> indikatorDetails = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    //fetchCarouselAndIndikators();
    fetchIndikatorUtama(); // 🔥

    tahunController = Get.find<TahunController>();

    selectedYear = tahunController.tahun.value;
    dashboardFuture = DashboardService.fetchDashboard(selectedYear);
  }

  void _changeYear(int year) {
    tahunController.setTahun(year); // 🔥 GLOBAL
    setState(() {
      selectedYear = year;
      dashboardFuture = DashboardService.fetchDashboard(year);
      fetchIndikatorUtama(); // 🔁 reload indikator
    });
  }

  Future<void> fetchIndikatorUtama() async {
    debugPrint('🔥 fetchIndikatorUtama DIPANGGIL');

    setState(() {
      loading = true;
      indikatorDetails.clear();
      notifications.clear();
    });

    try {
      final indikatorList = await IndikatorService.fetchIndikators();

      // Ambil semua indikator, bukan hanya 3
      final details = await Future.wait(
        indikatorList.map(
          (ind) =>
              IndikatorService.fetchIndikatorDetail(ind.slug, selectedYear),
        ),
      );

      // Optional: buat notifications untuk carousel (ambil 3 saja)
      final notif = details.take(3).map((d) {
        String description = '-';
        if (d.kategoris.isNotEmpty) {
          description = d.kategoris[0].deskripsi;
        }
        return {
          'title': d.namaIndikator,
          'description': description,
          'year': selectedYear.toString(),
        };
      }).toList();

      setState(() {
        indikatorDetails = details; // ✅ sekarang semua indikator ada
        notifications = notif;
      });
    } catch (e) {
      debugPrint('❌ ERROR fetchIndikatorUtama: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Future<void> fetchCarouselAndIndikators() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     final indikatorList = await IndikatorService.fetchIndikators();

  //     // Ambil detail + dataIndikators per tahun untuk carousel dan list
  //     final List<IndikatorDetail> details = [];
  //     for (var indikator in indikatorList) {
  //       final detail = await IndikatorService.fetchIndikatorWithData(
  //         indikator.slug,
  //         selectedYear,
  //       );
  //       details.add(detail);
  //     }

  //     // Map beberapa indikator menjadi "notifications" dummy carousel
  //     final List<Map<String, String>> notif = details.take(3).map((d) {
  //       String title = d.namaIndikator;
  //       String desc =
  //           d.kategoris.isNotEmpty && d.kategoris[0].dataIndikators.isNotEmpty
  //           ? '${d.kategoris[0].dataIndikators[0].nilai} ${d.kategoris[0].dataIndikators[0].satuan ?? 'Jiwa'}'
  //           : 'Tidak ada data';
  //       return {
  //         'title': title,
  //         'description': desc,
  //         'date': 'Tahun $selectedYear',
  //       };
  //     }).toList();

  //     setState(() {
  //       indikatorDetails = details;
  //       notifications = notif;
  //     });
  //   } catch (e) {
  //     debugPrint('❌ ERROR fetchCarouselAndIndikators: $e');
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  double posisiIndex(int index) => index * (230 + 12);

  int indexFromNotif(String title) {
    for (int i = 0; i < indikatorDetails.length; i++) {
      if (indikatorDetails[i].namaIndikator == title) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ================= BACKGROUND HIJAU =================
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF2D95C9),
                  Color(0xFF75B547),
                  Color(0xFFE18939),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  // ===== SWITCH TAHUN DI ATAS HEADER =====
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Indikator Strategis Tahun $selectedYear',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'BPS Kabupaten Solok',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bagian dropdown
                        DropdownButton<int>(
                          value: selectedYear,
                          items: _yearItems(),
                          onChanged: (value) {
                            if (value != null) _changeYear(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  CarouselSlider(
                    items: notifications.map((notif) {
                      return GestureDetector(
                        onTap: () {
                          final slug =
                              indikatorDetails[indexFromNotif(notif['title']!)]
                                  .slug;
                          Get.to(
                            () => const IndikatorDetailScreen(),
                            arguments: {'slug': slug},
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 160,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tahun ${notif['year']}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notif['title']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif['description']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      enlargeCenterPage:
                          true, // Ini yang bikin item tengah membesar
                      viewportFraction:
                          0.8, // Lebar tiap item (lebih kecil dari 1 agar terlihat item samping)
                    ),
                  ),
                ],
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.47,
            minChildSize: 0.47,
            maxChildSize: 0.78,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),

                            child: Hero(
                              tag: 'search-bar',
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Get.to(
                                      () => const SearchPage(),
                                      transition:
                                          Transition.fadeIn, // boleh ganti
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withAlpha(128),
                                          blurRadius: 5,
                                          offset: const Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.search,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Mau cari data apa?...',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ===== JUDUL =====
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Indikator Utama',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Ganti tab ke halaman Indikator (index 1)
                                  final BottomNavController
                                  bottomNavController = Get.find();
                                  bottomNavController.changeIndex(1);
                                },
                                child: Text(
                                  'Lihat semua',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2D95C9),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            height: 100,
                            child: indikatorDetails.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withAlpha(26),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'indikatorDetails KOSONG',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    controller: indikatorScrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: indikatorDetails.length,
                                    itemBuilder: (context, index) {
                                      final d = indikatorDetails[index];

                                      return GestureDetector(
                                        onTap: () {
                                          // 🔹 Pindah ke detail screen dengan slug indikator
                                          Get.to(
                                            () => const IndikatorDetailScreen(),
                                            arguments: {'slug': d.slug},
                                          );
                                        },
                                        child: Container(
                                          width: 230,
                                          margin: EdgeInsets.only(
                                            left: index == 0 ? 0 : 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: d.namaIndikator.isEmpty
                                                ? Colors
                                                      .orange[200] // indikator bermasalah
                                                : Colors.grey[100],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              d.namaIndikator.isNotEmpty
                                                  ? d.namaIndikator
                                                  : 'namaIndikator KOSONG',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: d.namaIndikator.isEmpty
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          SizedBox(height: 10),

                          // Angka Strategis Utama
                          // Center(
                          //   child: Container(
                          //     margin: const EdgeInsets.symmetric(
                          //       horizontal: 16,
                          //     ),
                          //     padding: const EdgeInsets.all(12),
                          //     decoration: BoxDecoration(
                          //       color: const Color(0xFF2D95C9),
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     child: Column(
                          //       children: [
                          //         Text(
                          //           'Angka Strategis Utama $selectedYear',
                          //           style: const TextStyle(
                          //             fontFamily: 'Poppins',
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w600,
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //         const SizedBox(height: 16),
                          //         GridView.count(
                          //           crossAxisCount: 2,
                          //           mainAxisSpacing: 10,
                          //           crossAxisSpacing: 10,
                          //           shrinkWrap: true,
                          //           physics:
                          //               const NeverScrollableScrollPhysics(),
                          //           childAspectRatio: 1.5,
                          //           children: indikatorDetails.take(6).map((d) {
                          //             final data =
                          //                 d.kategoris.isNotEmpty &&
                          //                     d
                          //                         .kategoris[0]
                          //                         .dataIndikators
                          //                         .isNotEmpty
                          //                 ? d.kategoris[0].dataIndikators[0]
                          //                 : null;
                          //             return buildStatCardSimple(
                          //               title: d.namaIndikator,
                          //               icon: Icons.bar_chart_rounded,
                          //               value: data?.nilai.toString() ?? '-',
                          //               unit: data?.satuan ?? '',
                          //             );
                          //           }).toList(),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 100),

                          Center(
                            child: Column(
                              children: [
                                Opacity(
                                  opacity: 0.7,
                                  child: Image.asset(
                                    'assets/images/logo_bps.png',
                                    height: 34,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Seluruh data bersumber dari',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Badan Pusat Statistik',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Kabupaten Solok • $selectedYear',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _yearItems() {
    final currentYear = DateTime.now().year;
    return List.generate(5, (index) {
      final year = currentYear - index;
      return DropdownMenuItem(value: year, child: Text(year.toString()));
    });
  }
}
