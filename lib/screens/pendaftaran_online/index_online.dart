import 'package:flutter/material.dart';

import 'input_kode.dart';
import 'scan_barcode.dart';

// ─── Theme constants (identik dengan file lain) ───────────────────────────────
const _kNavy = Color(0xFF00155E);
const _kNavy2 = Color(0xFF00155E);
const _kBlue1 = Color(0xFF00155E);
const _kBlue2 = Color(0xFF00155E);
const _kNeutral50 = Color(0xFFF4F6FA);
const _kNeutral100 = Color(0xFFEAEDF3);
const _kNeutral300 = Color(0xFFCDD1DC);
const _kNeutral500 = Color(0xFF8A90A0);
const _kText = Color(0xFF00155E);
const _kTextSub = Color(0xFF5A6070);
const _kTextHint = Color(0xFFB0B5C0);
const _kWhite = Colors.white;

class IndexOnlineScreen extends StatelessWidget {
  const IndexOnlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kNeutral50,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  // ─── Header dark navy ─────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_kNavy, _kNavy2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: _kWhite, size: 22),
                      onPressed: () => Navigator.maybePop(ctx),
                    ),
                  ),
                  const Text('Menu Pendaftaran',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _kWhite)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pendaftaran Online',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _kWhite,
                        letterSpacing: -0.3,
                      )),
                  SizedBox(height: 6),
                  Text(
                      'Pilih metode verifikasi untuk melanjutkan pendaftaran',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                          height: 1.4)),
                ],
              ),
            ),
          ],
        ),
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
          const _SectionLabel('METODE VERIFIKASI'),
          const SizedBox(height: 12),

          // ── Dua card kiri kanan ──
          Row(
            children: [
              Expanded(
                child: _MetodeCard(
                  icon: Icons.pin_outlined,
                  title: 'Input Kode\nBooking',
                  subtitle:
                      'Masukkan kode yang diterima saat mendaftar online',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => InputKodeScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetodeCard(
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'Scan\nBarcode',
                  subtitle:
                      'Arahkan kamera ke barcode pada kartu booking Anda',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ScanBarcodeScreen()),
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Info note ──
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _kWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kNeutral100, width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [_kBlue1, _kBlue2]),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Kode booking dan barcode diperoleh saat Anda mendaftar melalui aplikasi atau website klinik.',
                    style: TextStyle(
                        fontSize: 12,
                        color: _kTextSub,
                        height: 1.6),
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
          color: _kWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kNeutral100, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Accent line ──
              Container(
                height: 3,
                color: _kNavy,
              ),

              // ── Card content ──
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _kNavy,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: _kWhite, size: 26),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _kText,
                          height: 1.3,
                        )),
                    const SizedBox(height: 6),

                    // Subtitle
                    Text(subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _kTextSub,
                          height: 1.55,
                        )),
                  ],
                ),
              ),

              // ── Footer strip ──
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: _kNeutral50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kNeutral100, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ketuk untuk lanjut',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _kNeutral500,
                        )),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _kNavy,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: _kWhite,
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
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _kNeutral500,
            letterSpacing: 1.2));
  }
}