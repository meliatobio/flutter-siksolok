import 'package:flutter/material.dart';
import 'package:siksolok/models/about_model.dart';
import 'package:siksolok/services/about_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: FutureBuilder<List<About>>(
        future: AboutService.fetchAbouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("⏳ Waiting for about data...");
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("❌ FutureBuilder Error: ${snapshot.error}");
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final abouts = snapshot.data!;
          print("✅ Data loaded: ${abouts.length} items");

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...abouts.map((about) => _buildAccordion(about)),
              const SizedBox(height: 24),
              _buildFooter(),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
              colors: [Color(0xFF2D95C9), Color(0xFF75B547), Color(0xFFE18939)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 24, bottom: 25),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'About',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= ACCORDION =================
  Widget _buildAccordion(About about) {
    // Modifikasi: pakai about.imageUrl dari model
    String? imageUrl;
    if (about.imageUrl != null && about.imageUrl!.isNotEmpty) {
      // Ambil nama file dari imageUrl
      final uri = Uri.parse(about.imageUrl!);
      final filename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      if (filename.isNotEmpty) {
        // Gunakan API proxy Laravel
        imageUrl = 'http://localhost:8000/api/abouts/images/$filename';
      }
    }

    print("📌 About Title: ${about.title}");
    print("🖼️ Image URL: $imageUrl");

    return Column(
      children: [
        ExpansionTile(
          title: Text(
            about.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(221, 54, 51, 51),
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_down),
          childrenPadding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🖼️ GAMBAR
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            print("✅ Image loaded: $imageUrl");
                            return child;
                          }
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print("🚨 Image ERROR: $imageUrl");
                          print("❌ Error Detail: $error");
                          print("📍 StackTrace: $stackTrace");

                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Gambar tidak dapat dimuat',
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),

                  if (imageUrl != null) const SizedBox(height: 12),

                  /// 📄 KONTEN
                  Text(
                    about.content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 1, thickness: 0.5),
        const SizedBox(height: 8),
      ],
    );
  }

  // ================= FOOTER =================
  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Opacity(
            opacity: 0.7,
            child: Image.asset('assets/images/logo_bps.png', height: 34),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seluruh data bersumber dari',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const Text(
            'Badan Pusat Statistik',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const Text(
            'Kabupaten Solok • 2024',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
