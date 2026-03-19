import 'package:flutter/material.dart';

import '../../widgets/app_colors.dart';
import '../../widgets/kiosk_navbar.dart';
import 'input_kode.dart';
import 'scan_barcode.dart';

class IndexOnlineScreen extends StatelessWidget {
  const IndexOnlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.50,
              child: Image.asset(
                'Assets/background/image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            children: [
              KioskNavbar(
                title: 'Pendaftaran Online',
                subtitle: 'Pilih metode verifikasi untuk melanjutkan pendaftaran',
                backLabel: 'Menu Pendaftaran',
              ),
              Expanded(child: _buildBody(context)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          Text('METODE VERIFIKASI',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral500,
                  letterSpacing: 1.2)),
          const SizedBox(height: 12),

          // ── Dua card kiri kanan ──
          Row(
            children: [
              Expanded(
                child: _MetodeCard(
                  icon: Icons.pin_outlined,
                  title: 'Input Kode\nBooking',
                  subtitle: 'Masukkan kode yang diterima saat mendaftar online',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => InputKodeScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetodeCard(
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'Scan\nBarcode',
                  subtitle: 'Arahkan kamera ke barcode pada kartu booking Anda',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ScanBarcodeScreen()),
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Info note ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.neutral100, width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    gradient: AppColors.blueGradient,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Kode booking dan barcode diperoleh saat Anda mendaftar melalui aplikasi atau website klinik.',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSub, height: 1.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Premium Metode Card ──────────────────────────────────────────────────────
class _MetodeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MetodeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Card content ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.navyGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: AppColors.white, size: 28),
                  ),
                  const SizedBox(height: 18),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSub,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Footer strip ──
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.neutral50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.white, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pilih Metode',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: AppColors.blueGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
