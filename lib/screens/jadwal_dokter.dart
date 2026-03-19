import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: _kNeutral50,
      body: Column(
        children: [
          _buildHeader(),
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
    );
  }

  Widget _buildHeader() {
    final total = jadwal.length;
    final tersedia = jadwal.where((d) => d['status'] == 'Tersedia').length;
    final penuh = total - tersedia;

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
            // AppBar row
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
                  const Text('Menu Utama',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _kWhite)),
                  const Spacer(),
                ],
              ),
            ),
            // Title block
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jadwal Dokter',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _kWhite,
                        letterSpacing: -0.3,
                      )),
                  SizedBox(height: 6),
                  Text('Daftar dokter yang bertugas hari ini',
                      style: TextStyle(
                          fontSize: 13, color: Colors.white60, height: 1.4)),
                ],
              ),
            ),
            // Stats strip
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  _StatChip(label: 'Total', value: '$total'),
                  const SizedBox(width: 8),
                  _StatChip(
                    label: 'Tersedia',
                    value: '$tersedia',
                    color: const Color(0xFF4ADE80),
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    label: 'Penuh',
                    value: '$penuh',
                    color: const Color(0xFFF87171),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _kWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kNeutral100),
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
              color: _kTextHint,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: _kNeutral500,
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

// ─── Stat chip di header ──────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    this.color = _kWhite,
  });

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
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500)),
        ],
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
        color: _kWhite,
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
                gradient: _isTersedia
                    ? const LinearGradient(
                        colors: [_kBlue1, _kBlue2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: _isTersedia ? null : const Color(0xFFEAEDF3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.medical_services_rounded,
                color: _isTersedia ? _kWhite : _kNeutral500,
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
                          color: _kText)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Badge spesialis
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _kBlue1.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(data['spesialis']!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: _kBlue1,
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
                    color: _kNeutral50,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xFFEAEDF3), width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12, color: _kNeutral500),
                      const SizedBox(width: 4),
                      Text(
                        '$jamMulai – $jamSelesai',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _kText,
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
                    Icon(Icons.timelapse_rounded,
                        size: 11, color: _kNeutral500),
                    const SizedBox(width: 3),
                    Text(
                      _durasi(jamMulai, jamSelesai),
                      style: const TextStyle(
                        fontSize: 10,
                        color: _kNeutral500,
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
