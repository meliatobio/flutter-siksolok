import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siksolok/controllers/tahun_controller.dart';
import '../../models/indikator_model.dart';
import '../../services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TahunController tahunController;
  int selectedYear = DateTime.now().year;
  late Future<List<IndikatorModel>> dashboardFuture;

  @override
  void initState() {
    super.initState();

    // 🔥 AMBIL CONTROLLER GLOBAL
    tahunController = Get.find<TahunController>();

    selectedYear = tahunController.tahun.value;
    dashboardFuture = DashboardService.fetchDashboard(selectedYear);
  }

  void _changeYear(int year) {
    tahunController.setTahun(year); // 🔥 GLOBAL
    setState(() {
      selectedYear = year;
      dashboardFuture = DashboardService.fetchDashboard(year);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<IndikatorModel>>(
          future: dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final indikatorList = snapshot.data ?? [];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HEADER =====
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2D95C9), Color(0xFF6BCB77)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Indikator Strategis Tahun $selectedYear',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'BPS Kabupaten Solok',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // ===== FILTER TAHUN =====
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        const Text('Tahun:', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 12),
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

                  // ===== SEARCH =====
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Mau cari data apa?',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // ===== LIST =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Indikator Utama',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: indikatorList.length,
                    itemBuilder: (context, index) {
                      final indikator = indikatorList[index];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                indikator.namaIndikator,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                  'Jumlah data: ${indikator.dataIndikators.length}'),
                              if (indikator.dataIndikators.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  indikator.dataIndikators.first.deskripsi,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _yearItems() {
    final currentYear = DateTime.now().year;
    return List.generate(5, (index) {
      final year = currentYear - index;
      return DropdownMenuItem(
        value: year,
        child: Text(year.toString()),
      );
    });
  }
}
