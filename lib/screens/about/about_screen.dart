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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final abouts = snapshot.data!;

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
                  /// 🖼️ GAMBAR STRUKTUR ORGANISASI
                  if (about.imageUrl != null && about.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        about.imageUrl!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
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

                  if (about.imageUrl != null && about.imageUrl!.isNotEmpty)
                    const SizedBox(height: 12),

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
