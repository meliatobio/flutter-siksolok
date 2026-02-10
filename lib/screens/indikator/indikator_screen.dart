import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/app/routers.dart';
import 'package:siksolok/controllers/tahun_controller.dart';
import 'package:siksolok/models/indikator.dart';
import 'package:siksolok/services/indikator_service.dart';
import 'package:siksolok/utils/indikator_image_mapper.dart';

class IndikatorScreen extends StatelessWidget {
  IndikatorScreen({super.key});

  final TahunController tahunController = Get.find(); // 🔥 AMBIL TAHUN GLOBAL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ===== APP BAR =====
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2D95C9),
                  Color(0xFF75B547),
                  Color(0xFFE18939),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      children: const [
                        SizedBox(width: 8),
                        Text(
                          'Indikator Statistik',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      /// ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Pilih Indikator (${tahunController.tahun.value})',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            const SizedBox(height: 12),

            /// ===== LIST INDIKATOR =====
            Expanded(
              child: FutureBuilder<List<Indikator>>(
                future: IndikatorService.fetchIndikators(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final indikatorList = snapshot.data!;

                  return GridView.builder(
                    itemCount: indikatorList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final indikator = indikatorList[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.indikatorDetail,
                            arguments: {
                              'slug': indikator.slug,
                              'tahun': tahunController.tahun.value,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFE0E0E0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                               Container(
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFF2D95C9), // biru
        Color(0xFF75B547), // hijau
        Color(0xFFE18939), // oren
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Image.asset(
    IndikatorImageMapper.getImage(indikator.slug),
    width: 28,
    height: 28,
    fit: BoxFit.contain,
    color: Colors.white, // 🔥 icon kontras
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        'assets/images/default.png',
        width: 28,
        height: 28,
      );
    },
  ),
),

                                const SizedBox(height: 10),
                                Text(
                                  indikator.namaIndikator,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
