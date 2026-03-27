import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../widgets/kiosk_navbar.dart';

class JadwalDokterScreen extends StatefulWidget {
  const JadwalDokterScreen({super.key});

  @override
  State<JadwalDokterScreen> createState() => _JadwalDokterScreenState();
}

class _JadwalDokterScreenState extends State<JadwalDokterScreen> {
  String _searchQuery = '';

  final List<Map<String, String>> jadwal = const [
    {
      'dokter': 'Dr. Andi Pratama',
      'spesialis': 'Umum',
      'jam_mulai': '08:00',
      'jam_selesai': '11:00',
      'status': 'Tersedia',
    },
    {
      'dokter': 'Dr. Budi Santosa',
      'spesialis': 'Anak',
      'jam_mulai': '10:00',
      'jam_selesai': '13:00',
      'status': 'Tersedia',
    },
    {
      'dokter': 'Dr. Sinta Dewi',
      'spesialis': 'Kandungan',
      'jam_mulai': '13:00',
      'jam_selesai': '16:00',
      'status': 'Penuh',
    },
    {
      'dokter': 'Dr. Dewi',
      'spesialis': 'THT',
      'jam_mulai': '13:00',
      'jam_selesai': '16:00',
      'status': 'Penuh',
    },
    {
      'dokter': 'Dr. Farhan Akbar',
      'spesialis': 'Jantung',
      'jam_mulai': '15:00',
      'jam_selesai': '18:00',
      'status': 'Tersedia',
    },
  ];

  List<Map<String, String>> get _filteredJadwal {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return jadwal;

    return jadwal
        .where((item) => (item['dokter'] ?? '').toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final total = jadwal.length;
    final tersedia = jadwal.where((d) => d['status'] == 'Tersedia').length;
    final penuh = total - tersedia;

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
                title: 'Jadwal Dokter',
                subtitle: 'Daftar dokter yang bertugas hari ini',
                backLabel: 'Menu Utama',
                stats: [
                  NavStatChip(label: 'Total', value: '$total'),
                  NavStatChip(
                    label: 'Tersedia',
                    value: '$tersedia',
                    color: const Color(0xFF4ADE80),
                  ),
                  NavStatChip(
                    label: 'Penuh',
                    value: '$penuh',
                    color: const Color(0xFFF87171),
                  ),
                ],
              ),
              _buildSearchBar(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: _filteredJadwal.length,
                  itemBuilder: (context, index) =>
                      _DokterCard(data: _filteredJadwal[index]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.neutral100),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Cari dokter atau spesialis',
            hintStyle: TextStyle(
              color: AppColors.textHint,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.neutral500,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }
}

// ─── Card dokter ──────────────────────────────────────────────────────────────
class _DokterCard extends StatelessWidget {
  final Map<String, String> data;

  const _DokterCard({required this.data});

  bool get _isTersedia => data['status'] == 'Tersedia';

  /// Hitung durasi praktik dari jam_mulai ke jam_selesai
  String _durasi(String mulai, String selesai) {
    final parts = (s) => s.split(':').map(int.parse).toList();
    final m = parts(mulai);
    final s = parts(selesai);
    final menitTotal = (s[0] * 60 + s[1]) - (m[0] * 60 + m[1]);
    final jam = menitTotal ~/ 60;
    final menit = menitTotal % 60;
    if (menit == 0) return '$jam jam';
    return '$jam j ${menit} mnt';
  }

  @override
  Widget build(BuildContext context) {
    final jamMulai = data['jam_mulai']!;
    final jamSelesai = data['jam_selesai']!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEDF3), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: _isTersedia ? AppColors.blueGradient : null,
                color: _isTersedia ? null : const Color(0xFFEAEDF3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.medical_services_rounded,
                color: _isTersedia ? AppColors.white : AppColors.neutral500,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Info dokter
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['dokter']!,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Badge spesialis
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.blue1.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(data['spesialis']!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.blue1,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      const SizedBox(width: 8),
                      // Badge status
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _isTersedia
                              ? const Color(0xFF16A34A).withOpacity(0.10)
                              : const Color(0xFFDC2626).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: _isTersedia
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFDC2626),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(data['status']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _isTersedia
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFFDC2626),
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Jam mulai – selesai + durasi
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Pill jam
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xFFEAEDF3), width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 12, color: AppColors.neutral500),
                      const SizedBox(width: 4),
                      Text(
                        '$jamMulai – $jamSelesai',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Durasi
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timelapse_rounded,
                        size: 11, color: AppColors.neutral500),
                    const SizedBox(width: 3),
                    Text(
                      _durasi(jamMulai, jamSelesai),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.neutral500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
