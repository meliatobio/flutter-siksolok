import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/app/routers.dart';
import 'package:siksolok/models/indikator.dart';
import 'package:siksolok/services/indikator_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  List<Indikator> allIndikator = [];
  List<Indikator> results = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAllIndikator();
  }

  Future<void> loadAllIndikator() async {
    allIndikator = await IndikatorService.fetchIndikators();
  }

  void onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        results = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    results = allIndikator.where((item) {
      return item.namaIndikator.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== SEARCH BAR + BACK BUTTON =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 🔙 BACK BUTTON
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),

                  // 🔍 SEARCH BAR (HERO)
                  Expanded(
                    child: Hero(
                      tag: 'search-bar',
                      child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          onChanged: onSearch,
                          decoration: InputDecoration(
                            hintText: 'Cari indikator...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _controller.clear();
                                      onSearch('');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== CONTENT =====
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : results.isEmpty
                  ? const Center(
                      child: Text(
                        'Ketik untuk mencari indikator',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final indikator = results[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(indikator.namaIndikator),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.indikatorDetail,
                                arguments: {'slug': indikator.slug},
                              );
                            },
                          ),
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
