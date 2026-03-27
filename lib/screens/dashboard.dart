import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/dashboard_cards.dart';
import '../widgets/app_colors.dart';
import 'daftar/daftar_menu.dart';
import 'jadwal_dokter.dart';
import 'pendaftaran_online/index_online.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  List<MenuCardItem> _buildMenuItems(BuildContext context) {
    return [
      MenuCardItem(
        title: 'Daftar',
        subtitle: 'Pendaftaran pasien baru & lama',
        icon: Icons.edit_rounded,
        cardColor: const Color(0xFFEAF4F2), // Hijau pastel
        iconBg: Colors.white,
        iconColor: const Color(0xFF11B67A),
        onTap: () => _openPage(context, DaftarMenu()),
      ),
      MenuCardItem(
        title: 'Jadwal Dokter',
        subtitle: 'Cek jadwal & spesialisasi',
        icon: Icons.calendar_month_rounded,
        cardColor: const Color(0xFFEEF1FB), // Biru pastel
        iconBg: Colors.white,
        iconColor: const Color(0xFF4B66D8),
        onTap: () => _openPage(context, JadwalDokterScreen()),
      ),
      MenuCardItem(
        title: 'Pendaftaran Online',
        subtitle: 'Scan QR, antri dari rumah',
        icon: Icons.qr_code_2_rounded,
        cardColor: const Color(0xFFFEF3ED), // Oranye pastel
        iconBg: Colors.white,
        iconColor: const Color(0xFFE85D3F),
        onTap: () => _openPage(context, IndexOnlineScreen()),
      ),
      MenuCardItem(
        title: 'Admin',
        subtitle: 'Hubungi petugas untuk bantuan',
        icon: Icons.description_rounded,
        cardColor: const Color(0xFFFDF4FE), // Ungu pastel
        iconBg: Colors.white,
        iconColor: const Color(0xFF9B3FD4),
        onTap: () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEE, dd MMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.50, // Adjust opacity here
              child: Image.asset(
                'Assets/background/image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1100;
                final double contentMaxWidth = isDesktop ? 1180 : 900;

                return Column(
                  children: [
                    // Navbar - (Full Width)
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            isDesktop ? 40 : 24,
                            isDesktop ? 30 : 24,
                            isDesktop ? 40 : 24,
                            0,
                          ),
                          child: _buildTopBar(formattedDate),
                        ),
                      ),
                    ),
                    // Scrollable Body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          isDesktop ? 40 : 24,
                          20, // Reduced top padding after header
                          isDesktop ? 40 : 24,
                          isDesktop ? 30 : 24,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: contentMaxWidth - (isDesktop ? 80 : 48)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel('Layanan Utama'),
                                const SizedBox(height: 16),
                                DashboardMenuGrid(items: _buildMenuItems(context)),
                                const SizedBox(height: 32),
                                _buildSectionLabel('Informasi Hari Ini'),
                                const SizedBox(height: 16),
                                DashboardInfoRow(isDesktop: isDesktop),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── TOP BAR ────────────────────────────────────────────────────────────────

  Widget _buildTopBar(String date) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
              // Glass Reflection Line
              BoxShadow(
                color: Colors.white.withOpacity(0.95),
                blurRadius: 15,
                offset: const Offset(0, -6),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Logo/Icon with Multi-Layer Glow
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.blueGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue1.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.monitor_heart_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 18),
                  // App Title Block
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'RUMAH SAKIT DEMO',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'LAYANAN DIGITAL TERPADU',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.navy.withOpacity(0.6),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Premium Date Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 15,
                      color: AppColors.blue1,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SECTION LABEL ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Color(0xFFFFFFFFF),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEDEAE4).withOpacity(0.8),
                  const Color(0xFFEDEAE4).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
