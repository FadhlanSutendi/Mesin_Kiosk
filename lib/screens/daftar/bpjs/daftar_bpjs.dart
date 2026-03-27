import 'package:flutter/material.dart';
import '../../dashboard.dart';
import '../../../widgets/struk.dart';
import '../../../widgets/app_colors.dart';
import '../../../widgets/kiosk_navbar.dart';
import '../../../widgets/common_widgets.dart';

// ─── Main widget ──────────────────────────────────────────────────────────────
class DaftarBPJS extends StatefulWidget {
  const DaftarBPJS({super.key});

  @override
  State<DaftarBPJS> createState() => _DaftarBPJSState();
}

class _DaftarBPJSState extends State<DaftarBPJS> {
  final _noBpjsController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;
  Map<String, String>? _dataPasien;

  @override
  void initState() {
    super.initState();
    _focusNode
        .addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _noBpjsController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitNoBpjs() {
    FocusScope.of(context).unfocus();
    final input = _noBpjsController.text.trim();
    final noBpjs = input.isEmpty ? '0000000000000' : input;
    setState(() {
      _dataPasien = {
        'noBpjs': noBpjs,
        'nama': 'Andi Pratama',
        'nik': '3275010101900001',
        'tanggalLahir': '01-01-1990',
        'faskes': 'Puskesmas Sukamaju',
        'poli': 'Poli Umum',
        'status': 'Aktif',
      };
    });
  }

  void _daftarkanPasien() => _showStrukPreview(noAntrian: '12 B');

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
              // Header navy
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
                      child: const Icon(Icons.confirmation_number_rounded,
                          color: AppColors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Nomor Antrian BPJS',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white)),
                        SizedBox(height: 2),
                        Text('Pendaftaran berhasil diproses',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white60)),
                      ],
                    ),
                  ],
                ),
              ),

              // Antrian badge
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AntrianBadge(noAntrian: '12 B', estimasi: '± 20 mnt'),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Text(
                  'Pendaftaran berhasil. Silakan menunggu di ruang tunggu dan perhatikan layar panggilan.',
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
                          _showStrukPreview(noAntrian: '12 B');
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
    final pasien = _dataPasien;
    if (pasien == null) return;
    final namaPasien = (pasien['nama'] ?? '').trim();
    final poliTujuan = (pasien['poli'] ?? '').trim();
    final noBpjs = (pasien['noBpjs'] ?? '').trim();

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
              nama: namaPasien.isEmpty ? 'Pengunjung' : namaPasien,
              poli: poliTujuan.isEmpty
                  ? 'BPJS'
                  : 'BPJS - $poliTujuan (${noBpjs.isEmpty ? '0000000000000' : noBpjs})',
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
                        Text('Kembali',
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
            Text('Struk BPJS $noAntrian sedang dicetak…',
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
                title: 'Pendaftaran BPJS',
                subtitle: 'Masukkan nomor BPJS untuk mencari data peserta',
                backLabel: 'Menu Pendaftaran',
              ),
              Expanded(child: _buildBody()),
            ],
          ),
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
        const SectionLabel('NOMOR KARTU BPJS'),
        const SizedBox(height: 10),

        // ── Input BPJS ──
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused ? AppColors.blue1 : AppColors.neutral300,
              width: _isFocused ? 1.5 : 0.5,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                        color: AppColors.blue1.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : [],
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
                child: const Icon(Icons.credit_card_rounded,
                    color: AppColors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _noBpjsController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.text,
                      fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '13 digit nomor kartu BPJS',
                    hintStyle:
                        TextStyle(fontSize: 13, color: AppColors.textHint),
                    labelText: 'No. Kartu BPJS',
                    labelStyle:
                        TextStyle(fontSize: 12, color: AppColors.textSub),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── Info note ──
        const InfoNote(
            'Nomor BPJS terdiri dari 13 digit yang tertera di kartu peserta Anda.'),

        const SizedBox(height: 20),

        // ── Submit button ──
        GradientButton(
          label: 'Cari Data Peserta',
          icon: Icons.search_rounded,
          height: 54,
          fontSize: 15,
          onPressed: _submitNoBpjs,
        ),

        // ── Kartu info pasien (muncul setelah submit) ──
        if (_dataPasien != null) ...[
          const SizedBox(height: 28),
          _buildPasienCard(),
        ],

        const SizedBox(height: 20),
      ],
    );
  }

  // ─── Kartu informasi pasien ───────────────────────────────────────────────
  Widget _buildPasienCard() {
    final pasien = _dataPasien!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('DATA PESERTA DITEMUKAN'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.neutral100, width: 0.5),
          ),
          child: Column(
            children: [
              // Card header dengan avatar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: AppColors.navyGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: AppColors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pasien['nama'] ?? '-',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No. BPJS: ${pasien['noBpjs'] ?? '-'}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pasien['status'] ?? '-',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),

              // Data rows
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(
                        icon: Icons.badge_outlined,
                        label: 'NIK',
                        value: pasien['nik'] ?? '-'),
                    _InfoRow(
                        icon: Icons.cake_outlined,
                        label: 'Tanggal Lahir',
                        value: pasien['tanggalLahir'] ?? '-'),
                    _InfoRow(
                        icon: Icons.local_hospital_outlined,
                        label: 'Faskes',
                        value: pasien['faskes'] ?? '-'),
                    _InfoRow(
                        icon: Icons.medical_services_outlined,
                        label: 'Poli Tujuan',
                        value: pasien['poli'] ?? '-',
                        isLast: true),
                  ],
                ),
              ),

              // Tombol daftarkan
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GradientButton(
                  label: 'Daftarkan Pasien',
                  icon: Icons.how_to_reg_rounded,
                  height: 50,
                  onPressed: _daftarkanPasien,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Info row (dalam kartu pasien) ───────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
