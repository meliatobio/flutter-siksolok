import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/controllers/tahun_controller.dart';
import 'package:siksolok/models/detail_indikator_model.dart';
import 'package:siksolok/services/indikator_service.dart';
import 'package:siksolok/utils/parser.dart';
import 'dart:ui';

const String baseUrl = "http://localhost:8000";

/// 🔥 FIX CORS IMAGE URL
String fixImageUrl(String url) {
  return url.replaceFirst(
    '$baseUrl/storage/',
    '$baseUrl/api/image/',
  );
}

// Background kategori (asset)
final Map<String, String> kategoriBackgrounds = {
  'Kemiskinan': 'assets/images/bg_kemiskinan.png',
  'Pendidikan': 'assets/images/bg_pendidikan.png',
  'Kesehatan': 'assets/images/bg_kesehatan.png',
};

class IndikatorDetailScreen extends StatefulWidget {
  const IndikatorDetailScreen({super.key});

  @override
  State<IndikatorDetailScreen> createState() =>
      _IndikatorDetailScreenState();
}

class _IndikatorDetailScreenState
    extends State<IndikatorDetailScreen>
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

    indikatorFuture =
        IndikatorService.fetchIndikatorDetail(slug, tahun);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IndikatorDetail>(
      future: indikatorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
                child: Text('Error: ${snapshot.error}')),
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
              /// ================= BACKGROUND =================
              AnimatedBuilder(
                animation: tabController,
                builder: (context, child) {
                  final kategori =
                      indikator.kategoris[tabController.index];

                  final bgAsset =
                      kategoriBackgrounds[
                              kategori.namaKategori] ??
                          'assets/images/default_bg.png';

                  return Positioned.fill(
                    child: Stack(
                      children: [
                        Image.asset(
                          bgAsset,
                          fit: BoxFit.cover,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 4, sigmaY: 4),
                          child: Container(
                            color: Colors.black
                                .withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// ================= BACK BUTTON =================
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ),

              /// ================= CONTENT SHEET =================
              DraggableScrollableSheet(
                initialChildSize: 0.68,
                minChildSize: 0.68,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16),
                    child: Column(
                      children: [
                        /// Drag Handle
                        Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(
                              bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),

                        /// Judul
                        Text(
                          indikator.namaIndikator,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// ================= TAB BAR =================
                        if (indikator.kategoris.isNotEmpty)
                          SizedBox(
                            height: 48,
                            child: TabBar(
                              controller: tabController,
                              isScrollable: true,
                              indicator: BoxDecoration(
                                color:
                                    const Color(0xFFE18939),
                                borderRadius:
                                    BorderRadius.circular(
                                        30),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor:
                                  const Color(
                                      0xFFE18939),
                              tabs: indikator.kategoris
                                  .map((kategori) =>
                                      Tab(
                                        text: kategori
                                            .namaKategori,
                                      ))
                                  .toList(),
                            ),
                          ),

                        const SizedBox(height: 16),

                        /// ================= TAB VIEW =================
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: indikator
                                .kategoris
                                .map((kategori) {
                              return SingleChildScrollView(
                                controller:
                                    scrollController,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    /// Card
                                    Container(
                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors.white,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors
                                                .black
                                                .withOpacity(
                                                    0.08),
                                            blurRadius:
                                                20,
                                            offset:
                                                const Offset(
                                                    0, 10),
                                          ),
                                        ],
                                      ),
                                      padding:
                                          const EdgeInsets
                                              .all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          /// Deskripsi
                                          Text(
                                            parseKategoriDeskripsi(
                                              kategori
                                                  .deskripsi,
                                              2026,
                                            ),
                                            style:
                                                const TextStyle(
                                                    fontSize:
                                                        14),
                                          ),

                                          const SizedBox(
                                              height:
                                                  12),

                                          /// ================= IMAGE =================
                                          if (kategori
                                                  .gambar !=
                                              null &&
                                              kategori
                                                  .gambar!
                                                  .isNotEmpty)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          12),
                                              child:
                                                  Image.network(
                                                fixImageUrl(
                                                    kategori
                                                        .gambar!),
                                                width: double
                                                    .infinity,
                                                height: 180,
                                                fit: BoxFit
                                                    .cover,

                                                /// Loading
                                                loadingBuilder:
                                                    (context,
                                                        child,
                                                        loadingProgress) {
                                                  if (loadingProgress ==
                                                      null) {
                                                    return child;
                                                  }
                                                  return const SizedBox(
                                                    height:
                                                        180,
                                                    child:
                                                        Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                },

                                                /// Error
                                                errorBuilder:
                                                    (context,
                                                        error,
                                                        stackTrace) {
                                                  return const SizedBox(
                                                    height:
                                                        180,
                                                    child:
                                                        Center(
                                                      child:
                                                          Icon(
                                                        Icons
                                                            .broken_image,
                                                        size:
                                                            40,
                                                        color:
                                                            Colors.red,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 12),
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