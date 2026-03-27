import 'package:flutter/material.dart';
import '../../../widgets/app_colors.dart';
import '../../../widgets/kiosk_navbar.dart';
import 'umum_belum_terdaftar.dart';
import 'umum_terdaftar.dart';

class DaftarUmum extends StatelessWidget {
  const DaftarUmum({super.key});

  @override
  Widget build(BuildContext context) {
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
              KioskNavbar(
                title: 'Pilih Kategori',
                subtitle: 'Silahkan pilih jenis layanan pendaftaran anda',
                backLabel: 'Menu Pendaftaran',
              ),

              const SizedBox(height: 40),

              /// CARD MENU
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        context,
                        "Terdaftar",
                        Icons.person,
                        AppColors.blueGradient,
                        UmumTerdaftar(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildCard(
                        context,
                        "Belum\nTerdaftar",
                        Icons.person_add,
                        const LinearGradient(
                          colors: [Color(0xFF1E0DE1), Color(0xFF42028B)],
                        ),
                        UmumBelumTerdaftar(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    Gradient gradient,
    Widget page,
  ) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 190,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Pilih",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
