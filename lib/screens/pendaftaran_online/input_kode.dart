import 'package:flutter/material.dart';
import '../dashboard.dart';
import '../../widgets/struk.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/kiosk_navbar.dart';
import '../../widgets/common_widgets.dart';

// ─── Main widget ──────────────────────────────────────────────────────────────
class InputKodeScreen extends StatefulWidget {
  const InputKodeScreen({super.key});

  @override
  State<InputKodeScreen> createState() => _InputKodeScreenState();
}

class _InputKodeScreenState extends State<InputKodeScreen> {
  final _kodeController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;
  Map<String, String>? _dataPendaftaran;

  @override
  void initState() {
    super.initState();
    _focusNode
        .addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitKode() {
    FocusScope.of(context).unfocus();
    final input = _kodeController.text.trim();
    final kode = input.isEmpty ? 'BOOKING-DEMO-001' : input;
    setState(() {
      _dataPendaftaran = {
        'kodeBooking': kode,
        'nama': 'Pasien Online Demo',
        'poli': 'Poli Umum',
        'dokter': 'dr. Andini Putri',
        'jadwal': 'Senin, 08:30',
        'noAntrian': '18 O',
      };
    });
  }

  // ─── Dialog: Struk Preview ────────────────────────────────────────────────
  void _showStruk() {
    final data = _dataPendaftaran;
    if (data == null) return;

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
              nama: data['nama'] ?? '-',
              poli: data['poli'] ?? '-',
              nomorAntrian: data['noAntrian'] ?? '-',
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
                      _cetakStruk(data['noAntrian'] ?? '-');
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

  void _cetakStruk(String antrian) {
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
            Text('Struk online $antrian sedang dicetak…',
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
                title: 'Input Kode Booking',
                subtitle:
                    'Masukkan kode booking yang Anda terima saat mendaftar online',
                backLabel: 'Pendaftaran Online',
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
        const SectionLabel('KODE BOOKING'),
        const SizedBox(height: 10),

        // ── Input field ──
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
                child: const Icon(Icons.pin_outlined,
                    color: AppColors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _kodeController,
                  focusNode: _focusNode,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.text,
                      fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Contoh: BOOKING-XXX-001',
                    hintStyle:
                        TextStyle(fontSize: 13, color: AppColors.textHint),
                    labelText: 'Kode Booking',
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
          'Kode booking dapat ditemukan di email konfirmasi atau SMS yang dikirim saat pendaftaran online.',
        ),

        const SizedBox(height: 20),

        // ── Submit button ──
        GradientButton(
          label: 'Cari Data Booking',
          icon: Icons.search_rounded,
          height: 54,
          fontSize: 15,
          onPressed: _submitKode,
        ),

        // ── Kartu info pendaftaran ──
        if (_dataPendaftaran != null) ...[
          const SizedBox(height: 28),
          _buildInfoCard(),
        ],

        const SizedBox(height: 20),
      ],
    );
  }

  // ─── Kartu info pendaftaran ───────────────────────────────────────────────
  Widget _buildInfoCard() {
    final data = _dataPendaftaran!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('DATA PENDAFTARAN DITEMUKAN'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.neutral100, width: 0.5),
          ),
          child: Column(
            children: [
              // Card header navy
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
                      child: const Icon(Icons.receipt_long_rounded,
                          color: AppColors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['nama'] ?? '-',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kode: ${data['kodeBooking'] ?? '-'}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    // Antrian badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data['noAntrian'] ?? '-',
                        style: const TextStyle(
                            fontSize: 13,
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
                        icon: Icons.local_hospital_outlined,
                        label: 'Poli',
                        value: data['poli'] ?? '-'),
                    _InfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Dokter',
                        value: data['dokter'] ?? '-'),
                    _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Jadwal',
                        value: data['jadwal'] ?? '-',
                        isLast: true),
                  ],
                ),
              ),

              // Tombol cetak struk
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GradientButton(
                  label: 'Cetak Struk',
                  icon: Icons.receipt_long_rounded,
                  height: 50,
                  onPressed: _showStruk,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Info row (dalam kartu) ───────────────────────────────────────────────────
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
