import 'package:flutter/material.dart';
import '../../dashboard.dart';
import '../../../widgets/struk.dart';
import '../../../widgets/app_colors.dart';
import '../../../widgets/kiosk_navbar.dart';
import '../../../widgets/common_widgets.dart';

// ─── Main widget ──────────────────────────────────────────────────────────────
class DaftarSpesialis extends StatefulWidget {
  const DaftarSpesialis({super.key});

  @override
  State<DaftarSpesialis> createState() => _DaftarSpesialisState();
}

class _DaftarSpesialisState extends State<DaftarSpesialis> {
  final Map<String, List<String>> _spesialisDokter = {
    'Penyakit Dalam': [
      'dr. Budi Santosa, Sp.PD',
      'dr. Laila Rahma, Sp.PD',
    ],
    'Anak': [
      'dr. Nita Sari, Sp.A',
      'dr. Rian Putra, Sp.A',
    ],
    'Kandungan': [
      'dr. Sinta Dewi, Sp.OG',
      'dr. M. Aditia, Sp.OG',
    ],
    'Jantung': [
      'dr. Farhan Akbar, Sp.JP',
      'dr. Maya Lestari, Sp.JP',
    ],
  };

  late String _selectedSpesialis;
  late String _selectedDokter;

  @override
  void initState() {
    super.initState();
    _selectedSpesialis = _spesialisDokter.keys.first;
    _selectedDokter = _spesialisDokter[_selectedSpesialis]!.first;
  }

  List<String> get _daftarDokter => _spesialisDokter[_selectedSpesialis]!;

  void _daftarkan() => _showStrukPreview(noAntrian: '27 S');

  // ─── Dialog: Nomor Antrian ────────────────────────────────────────────────
  void _showAntrianDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                decoration: const BoxDecoration(
                  gradient: AppColors.navyGradient,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.check_circle_rounded,
                          color: AppColors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Pendaftaran Berhasil',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white)),
                        SizedBox(height: 2),
                        Text('Anda terdaftar ke poli spesialis',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white60)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AntrianBadge(noAntrian: '27 S', estimasi: '± 30 mnt'),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Text(
                  'Silakan menunggu di ruang tunggu. Nomor antrian Anda akan dipanggil melalui layar dan pengeras suara.',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSub, height: 1.6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlineBtn(
                        label: 'Tutup',
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: GradientButton(
                        label: 'Lihat Struk',
                        icon: Icons.receipt_long_rounded,
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showStrukPreview(noAntrian: '27 S');
                        },
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

  // ─── Dialog: Struk Preview ────────────────────────────────────────────────
  void _showStrukPreview({required String noAntrian}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StrukWidget(
              rumahSakit: 'KLINIK SEHAT SENTOSA',
              nama: 'Pasien Demo',
              poli: _selectedSpesialis,
              nomorAntrian: noAntrian,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded,
                            size: 14, color: AppColors.white),
                        SizedBox(width: 6),
                        Text('Tutup',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _cetakStruk(noAntrian);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.print_rounded,
                            size: 14, color: AppColors.white),
                        SizedBox(width: 6),
                        Text('Cetak',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _cetakStruk(String noAntrian) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.blue2, size: 18),
            const SizedBox(width: 10),
            Text('Struk spesialis $noAntrian sedang dicetak…',
                style: const TextStyle(fontSize: 13, color: AppColors.white)),
          ],
        ),
      ),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: Column(
        children: [
          KioskNavbar(
            title: 'Poli Spesialis',
            subtitle: 'Pilih spesialis dan dokter yang ingin Anda tuju',
            backLabel: 'Menu Pendaftaran',
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 4),

        // ── Pilih Spesialis ──
        const SectionLabel('PILIH SPESIALIS'),
        const SizedBox(height: 10),
        _buildDropdownField(
          icon: Icons.biotech_outlined,
          label: 'Spesialis Tujuan',
          hint: 'Pilih spesialis',
          value: _selectedSpesialis,
          items: _spesialisDokter.keys.toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedSpesialis = value;
              _selectedDokter = _spesialisDokter[value]!.first;
            });
          },
        ),

        const SizedBox(height: 12),

        // ── Pilih Dokter ──
        const SectionLabel('PILIH DOKTER'),
        const SizedBox(height: 10),
        _buildDropdownField(
          icon: Icons.person_outline_rounded,
          label: 'Dokter',
          hint: 'Pilih dokter',
          value: _selectedDokter,
          items: _daftarDokter,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedDokter = value);
          },
        ),

        const SizedBox(height: 24),

        // ── Ringkasan ──
        const SectionLabel('RINGKASAN KUNJUNGAN'),
        const SizedBox(height: 10),
        _buildRingkasanCard(),

        const SizedBox(height: 28),

        // ── Tombol daftar ──
        GradientButton(
          label: 'Daftarkan Sekarang',
          icon: Icons.how_to_reg_rounded,
          height: 54,
          fontSize: 15,
          onPressed: _daftarkan,
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ─── Dropdown field builder ───────────────────────────────────────────────
  Widget _buildDropdownField({
    required IconData icon,
    required String label,
    required String hint,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral300, width: 0.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.text,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                labelStyle:
                    const TextStyle(fontSize: 12, color: AppColors.textSub),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: hint,
                hintStyle:
                    const TextStyle(fontSize: 13, color: AppColors.textHint),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.neutral500),
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              isExpanded: true,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }

  // ─── Ringkasan kunjungan ──────────────────────────────────────────────────
  Widget _buildRingkasanCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral100, width: 0.5),
      ),
      child: Column(
        children: [
          _RingkasanRow(
            icon: Icons.biotech_outlined,
            label: 'Spesialis',
            value: _selectedSpesialis,
          ),
          _RingkasanRow(
            icon: Icons.person_outline_rounded,
            label: 'Dokter',
            value: _selectedDokter,
          ),
          _RingkasanRow(
            icon: Icons.account_circle_outlined,
            label: 'Nama Pasien',
            value: 'Pasien Demo',
          ),
          _RingkasanRow(
            icon: Icons.check_circle_outline_rounded,
            label: 'Status',
            value: 'Siap Daftar',
            isLast: true,
            valueColor: const Color(0xFF16A34A),
          ),
        ],
      ),
    );
  }
}

// ─── Ringkasan row ────────────────────────────────────────────────────────────
class _RingkasanRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  final Color? valueColor;

  const _RingkasanRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.neutral100, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: AppColors.neutral500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSub)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                      fontSize: 13,
                      color: valueColor ?? AppColors.text,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
