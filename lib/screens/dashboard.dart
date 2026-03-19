import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEE, dd MMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1100;
          final double contentMaxWidth = isDesktop ? 1180 : 900;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 24,
                  vertical: isDesktop ? 30 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(formattedDate),
                    const SizedBox(height: 28),
                    _buildSectionLabel('Layanan Utama'),
                    const SizedBox(height: 12),
                    _buildMenuGrid(context),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Informasi Hari Ini'),
                    const SizedBox(height: 12),
                    _buildInfoRow(isDesktop: isDesktop),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── TOP BAR ────────────────────────────────────────────────────────────────

  Widget _buildTopBar(String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF00155E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.monitor_heart_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Selamat datang di',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9B96),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'RS Dashboard Demo',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1C1C1A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEDEAE4)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5A5855),
            ),
          ),
        ),
      ],
    );
  }

  // ─── SECTION LABEL ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF9E9B96),
        letterSpacing: 1.0,
      ),
    );
  }

  // ─── MENU GRID ───────────────────────────────────────────────────────────────

  Widget _buildMenuGrid(BuildContext context) {
    final List<_MenuItem> items = [
      _MenuItem(
        title: 'Daftar',
        subtitle: 'Pendaftaran pasien baru & lama',
        icon: Icons.edit_rounded,
        iconBg: const Color(0xFFEAF4F2),
        iconColor: const Color.fromARGB(255, 6, 183, 35),
        onTap: () => _openPage(context, DaftarMenu()),
      ),
      _MenuItem(
        title: 'Jadwal Dokter',
        subtitle: 'Cek jadwal & spesialisasi',
        icon: Icons.calendar_month_rounded,
        iconBg: const Color(0xFFEEF1FB),
        iconColor: const Color(0xFF4B66D8),
        onTap: () => _openPage(context, JadwalDokterScreen()),
      ),
      _MenuItem(
        title: 'Pendaftaran Online',
        subtitle: 'Scan QR, antri dari rumah',
        icon: Icons.qr_code_2_rounded,
        iconBg: const Color(0xFFFEF3ED),
        iconColor: const Color(0xFFE85D3F),
        onTap: () => _openPage(context, IndexOnlineScreen()),
      ),
      _MenuItem(
        title: 'Admin',
        subtitle: 'Hubungi petugas untuk bantuan',
        icon: Icons.description_rounded,
        iconBg: const Color(0xFFFDF4FE),
        iconColor: const Color(0xFF9B3FD4),
        onTap: () {},
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.45,
      children: items.map((item) => _buildMenuCard(item)).toList(),
    );
  }

  Widget _buildMenuCard(_MenuItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEDEAE4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9E9B96),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── INFO ROW ────────────────────────────────────────────────────────────────

  Widget _buildInfoRow({required bool isDesktop}) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            label: 'Antrian Aktif',
            value: '47',
            sub: 'pasien menunggu',
            showBadge: false,
            isDesktop: isDesktop,
          ),
        ),
        SizedBox(width: isDesktop ? 16 : 12),
        Expanded(
          child: _buildInfoCard(
            label: 'Dokter Aktif',
            value: '5',
            sub: '',
            showBadge: true,
            isDesktop: isDesktop,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required String sub,
    required bool showBadge,
    required bool isDesktop,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: isDesktop ? 180 : 160),
      padding: EdgeInsets.all(isDesktop ? 22 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: isDesktop ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9E9B96),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 40 : 34,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1C1A),
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          if (showBadge)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 10 : 8,
                vertical: isDesktop ? 5 : 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 12, 157, 17),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'online sekarang',
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 10,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 3, 160, 3),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              sub,
              style: TextStyle(
                fontSize: isDesktop ? 13 : 12,
                color: const Color(0xFFB0ADA8),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── DATA MODEL ──────────────────────────────────────────────────────────────

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });
}
