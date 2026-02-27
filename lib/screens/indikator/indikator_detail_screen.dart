import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/controllers/tahun_controller.dart';
import 'package:siksolok/models/detail_indikator_model.dart';
import 'package:siksolok/services/indikator_service.dart';
import 'package:siksolok/utils/parser.dart';
import 'dart:ui';

const String baseUrl = "http://127.0.0.1:8000";

// Background kategori
final Map<String, String> kategoriBackgrounds = {
  'Kemiskinan': 'assets/images/bg_kemiskinan.png',
  'Pendidikan': 'assets/images/bg_pendidikan.png',
  'Kesehatan': 'assets/images/bg_kesehatan.png',
};

class IndikatorDetailScreen extends StatefulWidget {
  const IndikatorDetailScreen({super.key});

  @override
  State<IndikatorDetailScreen> createState() => _IndikatorDetailScreenState();
}

class _IndikatorDetailScreenState extends State<IndikatorDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<IndikatorDetail> indikatorFuture;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    final String slug = args['slug'];
    final TahunController tahunController = Get.find();
    final int tahun = tahunController.tahun.value;
    indikatorFuture = IndikatorService.fetchIndikatorDetail(slug, tahun);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IndikatorDetail>(
      future: indikatorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final indikator = snapshot.data!;
        tabController = TabController(
          length: indikator.kategoris.length,
          vsync: this,
          initialIndex: Get.arguments['initialTab'] ?? 0,
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Background Image + Blur
              AnimatedBuilder(
                animation: tabController,
                builder: (context, child) {
                  final currentIndex = tabController.index;
                  final kategori = indikator.kategoris[currentIndex];
                  final bgAsset =
                      kategoriBackgrounds[kategori.namaKategori] ??
                          'assets/images/default_bg.png';
                  return Positioned.fill(
                    child: Stack(
                      children: [
                        Image.asset(bgAsset, fit: BoxFit.cover),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Back button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ),

              // Draggable Scrollable Sheet
              DraggableScrollableSheet(
                initialChildSize: 0.68,
                minChildSize: 0.68,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Judul indikator
                        Text(
                          indikator.namaIndikator,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // TabBar
                        if (indikator.kategoris.isNotEmpty)
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TabBar(
                              controller: tabController,
                              indicator: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.blue,
                              labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              tabs: indikator.kategoris
                                  .map((kategori) => Tab(
                                        child: Center(
                                          child: Text(kategori.namaKategori),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // TabBarView
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: indikator.kategoris.map((kategori) {
                              return SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Card konten
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              parseKategoriDeskripsi(
                                                  kategori.deskripsi, 2026),
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(height: 12),
                                            if (kategori.gambar != null &&
                                                kategori.gambar!.isNotEmpty)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  "$baseUrl/storage/${kategori.gambar}",
                                                  width: double.infinity,
                                                  height: 180,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (context, child, progress) {
                                                    if (progress == null) return child;
                                                    return const SizedBox(
                                                      height: 180,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (context, error, stackTrace) {
                                                    return SizedBox(
                                                      height: 180,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Icon(
                                                              Icons.broken_image,
                                                              size: 40,
                                                              color: Colors.red,
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              "Gagal load gambar",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              );
                            }).toList(),
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
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:siksolok/controllers/tahun_controller.dart';
// import 'package:siksolok/models/detail_indikator_model.dart';
// import 'package:siksolok/services/indikator_service.dart';
// import 'package:siksolok/utils/parser.dart';

// // Base URL untuk gambar kategori dari backend
// const String baseUrl = "http://127.0.0.1:8000";

// // Map kategori ke asset image background
// final Map<String, String> kategoriBackgrounds = {
//   'Kemiskinan': 'assets/images/bg_kemiskinan.png',
//   'Pendidikan': 'assets/images/bg_pendidikan.png',
//   'Kesehatan': 'assets/images/bg_kesehatan.png',
//   // Tambahkan kategori dan gambar sesuai kebutuhan
// };

// class IndikatorDetailScreen extends StatelessWidget {
//   const IndikatorDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments as Map<String, dynamic>;
//     final String slug = args['slug'];

//     final TahunController tahunController = Get.find();
//     final int tahun = tahunController.tahun.value;
//     final int initialTab = args['initialTab'] ?? 0;

//     return FutureBuilder<IndikatorDetail>(
//       future: IndikatorService.fetchIndikatorDetail(slug, tahun),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(child: Text('Error: ${snapshot.error}')),
//           );
//         }
//         final indikator = snapshot.data;
//         if (indikator == null) {
//           return const Scaffold(
//             body: Center(child: Text('Data tidak ditemukan')),
//           );
//         }

//         return DefaultTabController(
//           length: indikator.kategoris.length,
//           initialIndex: initialTab,
//           child: Builder(
//             builder: (context) {
//               final tabController = DefaultTabController.of(context);

//               return Scaffold(
//                 backgroundColor: Colors.white,
//                 body: Stack(
//                   children: [
//                     // Background Image dari asset sesuai tab yang aktif
//                     AnimatedBuilder(
//                       animation: tabController,
//                       builder: (context, child) {
//                         final currentIndex = tabController.index;
//                         final kategori = indikator.kategoris[currentIndex];
//                         final bgAsset =
//                             kategoriBackgrounds[kategori.namaKategori] ??
//                             'assets/images/default_bg.png'; // fallback jika tidak ada

//                         return Positioned.fill(
//                           child: Image.asset(bgAsset, fit: BoxFit.cover),
//                         );
//                       },
//                     ),

//                     // Tombol Back di atas background (posisi top-left)
//                     SafeArea(
//                       child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: CircleAvatar(
//                           backgroundColor: Colors.black38,
//                           child: IconButton(
//                             icon: const Icon(
//                               Icons.arrow_back,
//                               color: Colors.white,
//                             ),
//                             onPressed: () => Get.back(),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Draggable Scrollable Sheet putih dengan konten
//                     DraggableScrollableSheet(
//                       initialChildSize: 0.68,
//                       minChildSize: 0.68,
//                       maxChildSize: 0.95,
//                       builder: (context, scrollController) {
//                         return Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(30),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 10,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Drag handle
//                               Center(
//                                 child: Container(
//                                   width: 40,
//                                   height: 5,
//                                   margin: const EdgeInsets.only(bottom: 16),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[300],
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),

//                               // Judul indikator + lokasi
//                               Text(
//                                 'Indikator ${indikator.namaIndikator}',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 'Kabupaten Solok',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),

//                               // TabBar kategori
//                               if (indikator.kategoris.isNotEmpty)
//                                 TabBar(
//                                   isScrollable: true,
//                                   labelColor: Colors.white,
//                                   unselectedLabelColor: Colors.blue,
//                                   indicator: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: Colors.blue,
//                                   ),
//                                   tabs: indikator.kategoris
//                                       .map(
//                                         (kategori) =>
//                                             Tab(text: kategori.namaKategori),
//                                       )
//                                       .toList(),
//                                 ),

//                               // Konten TabBarView
//                               Expanded(
//                                 child: TabBarView(
//                                   children: indikator.kategoris.map((kategori) {
//                                     return SingleChildScrollView(
//                                       controller: scrollController,
//                                       padding: const EdgeInsets.only(top: 16),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             parseKategoriDeskripsi(
//                                               kategori.deskripsi,
//                                               tahun,
//                                             ),
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 12),
//                                           if (kategori.gambar != null &&
//                                               kategori.gambar!.isNotEmpty)
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                               child: Image.network(
//                                                 "$baseUrl/storage/${kategori.gambar}",
//                                                 width: double.infinity,
//                                                 height: 180,
//                                                 fit: BoxFit.cover,
//                                                 loadingBuilder:
//                                                     (
//                                                       context,
//                                                       child,
//                                                       loadingProgress,
//                                                     ) {
//                                                       if (loadingProgress ==
//                                                           null) {
//                                                         return child;
//                                                       }
//                                                       return const SizedBox(
//                                                         height: 180,
//                                                         child: Center(
//                                                           child:
//                                                               CircularProgressIndicator(),
//                                                         ),
//                                                       );
//                                                     },
//                                                 errorBuilder:
//                                                     (
//                                                       context,
//                                                       error,
//                                                       stackTrace,
//                                                     ) {
//                                                       return SizedBox(
//                                                         height: 180,
//                                                         child: Center(
//                                                           child: Column(
//                                                             mainAxisSize:
//                                                                 MainAxisSize
//                                                                     .min,
//                                                             children: const [
//                                                               Icon(
//                                                                 Icons
//                                                                     .broken_image,
//                                                                 size: 40,
//                                                                 color:
//                                                                     Colors.red,
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 4,
//                                                               ),
//                                                               Text(
//                                                                 "Gagal load gambar",
//                                                                 style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   color: Colors
//                                                                       .red,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
