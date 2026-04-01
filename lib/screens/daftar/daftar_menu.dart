import 'package:flutter/material.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/kiosk_navbar.dart';
import '../jadwal_dokter.dart';
import 'bpjs/daftar_bpjs.dart';
import 'spesialis/daftar_spesialis.dart';
import 'umum/daftar_umum.dart';

class DaftarMenu extends StatelessWidget {
  const DaftarMenu({super.key});

  Widget _buildHorizontalCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required Widget page,
    required double width,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Holder
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: Icon(icon, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 25),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Daftar Sekarang",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double paddingSize = 30.0;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.50,
              child: Image.asset(
                'Assets/background/image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // ── Navbar menggunakan widget reusable ──
              KioskNavbar(
                title: 'Pilih Kategori',
                subtitle: 'Silahkan pilih jenis layanan pendaftaran anda',
                backLabel: 'Menu Utama',
                showJadwalDokter: true,
                onJadwalDokterTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const JadwalDokterScreen()),
                  );
                },
              ),

              // ── Content ──
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double spacing = 20.0;
                    double cardWidth = (constraints.maxWidth -
                            (paddingSize * 2) -
                            (spacing * 2)) /
                        3;
                    if (cardWidth < 200) cardWidth = 250;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          // Menu Horizontal Area
                          SizedBox(
                            height: 350,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: paddingSize),
                              physics: const BouncingScrollPhysics(),
                              children: [
                                _buildHorizontalCard(
                                  context: context,
                                  title: "Umum",
                                  icon: Icons.person_pin_rounded,
                                  gradientColors: [
                                    const Color(0xFF1E3C72),
                                    const Color(0xFF2A5298)
                                  ],
                                  page: DaftarUmum(),
                                  width: cardWidth,
                                ),
                                _buildHorizontalCard(
                                  context: context,
                                  title: "BPJS",
                                  icon: Icons.security_rounded,
                                  gradientColors: [
                                    AppColors.blue1,
                                    const Color(0xFF2448C3)
                                  ],
                                  page: DaftarBPJS(),
                                  width: cardWidth,
                                ),
                                _buildHorizontalCard(
                                  context: context,
                                  title: "Spesialis",
                                  icon: Icons.biotech_rounded,
                                  gradientColors: [
                                    const Color(0xFF006DD4),
                                    const Color(0xFF2966F4)
                                  ],
                                  page: DaftarSpesialis(),
                                  width: cardWidth,
                                ),
                              ],
                            ),
                          ),

                          // Info Layanan
                          Padding(
                            padding: const EdgeInsets.all(paddingSize),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.96),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color:
                                      const Color(0xFF0B2A6F).withOpacity(0.10),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0B2A6F)
                                        .withOpacity(0.12),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0B2A6F)
                                              .withOpacity(0.10),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: const Icon(
                                          Icons.info_outline_rounded,
                                          color: AppColors.navy,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Informasi Layanan",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.navy,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Lihat ringkasan layanan rumah sakit dengan tampilan yang lebih jelas.",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF4E648E),
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: AppColors.navy,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Container(
                                                  width: 320,
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        "Informasi Layanan",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors.navy,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      const Text(
                                                        "Menyediakan layanan medis, penunjang medis, IGD, rawat inap, administrasi, layanan khusus, serta informasi jam operasional untuk membantu pasien mendapatkan pelayanan kesehatan.",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black87,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors.navy,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Tutup",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
