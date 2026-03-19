import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ─── Chip statistik kecil di dalam header (opsional) ─────────────────────────
class NavStatChip {
  final String label;
  final String value;
  final Color color;

  const NavStatChip({
    required this.label,
    required this.value,
    this.color = AppColors.white,
  });
}

/// ─── KioskNavbar ────────────────────────────────────────────────────────────
/// Navbar reusable untuk seluruh halaman mesin kiosk.
///
/// Contoh penggunaan:
/// ```dart
/// KioskNavbar(
///   title: 'Jadwal Dokter',
///   subtitle: 'Daftar dokter yang bertugas hari ini',
///   backLabel: 'Menu Utama',
///   stats: [ NavStatChip(label: 'Total', value: '5') ],
/// )
/// ```
///
/// Parameter [showJadwalDokter] adalah opsional; kalau `true` menampilkan
/// tombol shortcut "Jadwal Dokter" di pojok kanan header.
class KioskNavbar extends StatelessWidget {
  /// Judul utama yang besar
  final String title;

  /// Deskripsi pendek di bawah judul
  final String subtitle;

  /// Teks di samping tombol back (misal "Menu Utama", "Menu Pendaftaran")
  final String backLabel;

  /// Kalau `null`, tombol back tidak ditampilkan (untuk halaman root)
  final VoidCallback? onBack;

  /// Chip‐chip statistik di bawah subtitle (opsional)
  final List<NavStatChip> stats;

  /// Tampilkan shortcut "Jadwal Dokter" — opsional, default false
  final bool showJadwalDokter;

  /// Callback ketika shortcut jadwal dokter ditekan
  final VoidCallback? onJadwalDokterTap;

  /// Widget tambahan di bawah stats (opsional, misal search bar)
  final Widget? bottom;

  const KioskNavbar({
    super.key,
    required this.title,
    this.subtitle = '',
    this.backLabel = 'Kembali',
    this.onBack,
    this.stats = const [],
    this.showJadwalDokter = false,
    this.onJadwalDokterTap,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.navyGradient,
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
            // ── Row: Back + label + optional jadwal ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  if (onBack != null)
                    _BackButton(onTap: onBack!)
                  else
                    Builder(
                      builder: (ctx) => _BackButton(
                        onTap: () => Navigator.maybePop(ctx),
                      ),
                    ),
                  Text(
                    backLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  if (showJadwalDokter)
                    _JadwalShortcut(onTap: onJadwalDokterTap),
                ],
              ),
            ),

            // ── Title block ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Stats strip ──
            if (stats.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stats.map((s) => _StatChipWidget(chip: s)).toList(),
                ),
              ),

            // ── Bottom extra widget (search bar dll) ──
            if (bottom != null) bottom!,

            SizedBox(height: bottom != null ? 14 : 20),
          ],
        ),
      ),
    );
  }
}

// ─── Private helper widgets ──────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: AppColors.white,
        size: 22,
      ),
      onPressed: onTap,
    );
  }
}

class _StatChipWidget extends StatelessWidget {
  final NavStatChip chip;
  const _StatChipWidget({required this.chip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            chip.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: chip.color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            chip.label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shortcut button jadwal dokter di header (opsional)
class _JadwalShortcut extends StatelessWidget {
  final VoidCallback? onTap;
  const _JadwalShortcut({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 0.5,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month_rounded,
                  color: AppColors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'Jadwal Dokter',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
