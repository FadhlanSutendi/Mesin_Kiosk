import 'package:flutter/material.dart';
import '../../dashboard.dart';
import '../../../widgets/struk.dart';

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
                  gradient: LinearGradient(
                    colors: [_kNavy, _kNavy2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                          color: _kWhite, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Nomor Antrian BPJS',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _kWhite)),
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
                child: _AntrianBadge(noAntrian: '12 B', estimasi: '± 20 mnt'),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Text(
                  'Pendaftaran berhasil. Silakan menunggu di ruang tunggu dan perhatikan layar panggilan.',
                  style: TextStyle(fontSize: 13, color: _kTextSub, height: 1.6),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _OutlineButton(
                        label: 'Tutup',
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _GradientButton(
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
                      backgroundColor: _kBlue1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded, size: 14, color: _kWhite),
                        SizedBox(width: 6),
                        Text('Kembali',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _kWhite)),
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
                      backgroundColor: _kBlue1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.print_rounded, size: 14, color: _kWhite),
                        SizedBox(width: 6),
                        Text('Cetak',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _kWhite)),
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
        backgroundColor: _kNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: _kBlue2, size: 18),
            const SizedBox(width: 10),
            Text('Struk BPJS $noAntrian sedang dicetak…',
                style: const TextStyle(fontSize: 13, color: _kWhite)),
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
      backgroundColor: _kNeutral50,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: _kWhite, size: 22),
                    onPressed: () => Navigator.maybePop(context),
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
                  Text('Pendaftaran BPJS',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _kWhite,
                        letterSpacing: -0.3,
                      )),
                  SizedBox(height: 6),
                  Text('Masukkan nomor BPJS untuk mencari data peserta',
                      style: TextStyle(
                          fontSize: 13, color: Colors.white60, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 4),
        const _SectionLabel('NOMOR KARTU BPJS'),
        const SizedBox(height: 10),

        // ── Input BPJS ──
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _kWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused ? _kBlue1 : _kNeutral300,
              width: _isFocused ? 1.5 : 0.5,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                        color: _kBlue1.withOpacity(0.12),
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
                  gradient: const LinearGradient(
                    colors: [_kBlue1, _kBlue2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.credit_card_rounded,
                    color: _kWhite, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _noBpjsController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 14, color: _kText, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '13 digit nomor kartu BPJS',
                    hintStyle: TextStyle(fontSize: 13, color: _kTextHint),
                    labelText: 'No. Kartu BPJS',
                    labelStyle: TextStyle(fontSize: 12, color: _kTextSub),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  gradient: const LinearGradient(colors: [_kBlue1, _kBlue2]),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Nomor BPJS terdiri dari 13 digit yang tertera di kartu peserta Anda.',
                  style: TextStyle(fontSize: 12, color: _kTextSub, height: 1.6),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Submit button ──
        _GradientButton(
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
        const _SectionLabel('DATA PESERTA DITEMUKAN'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _kWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kNeutral100, width: 0.5),
          ),
          child: Column(
            children: [
              // Card header dengan avatar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_kNavy, _kNavy2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                        gradient: const LinearGradient(
                          colors: [_kBlue1, _kBlue2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: _kWhite, size: 26),
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
                              color: _kWhite,
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
                        gradient:
                            const LinearGradient(colors: [_kBlue1, _kBlue2]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pasien['status'] ?? '-',
                        style: const TextStyle(
                            fontSize: 11,
                            color: _kWhite,
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
                child: _GradientButton(
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
            : const Border(bottom: BorderSide(color: _kNeutral100, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _kNeutral50,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: _kNeutral500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11, color: _kTextSub)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13,
                        color: _kText,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
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

// ─── Gradient button ──────────────────────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final double height;
  final double fontSize;

  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 48,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_kBlue1, _kBlue2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _kBlue1.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: _kWhite,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label,
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Outline button ───────────────────────────────────────────────────────────
class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const _OutlineButton(
      {required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _kTextSub,
          side: const BorderSide(color: _kNeutral300, width: 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 8),
            ],
            Text(label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─── Antrian badge ────────────────────────────────────────────────────────────
class _AntrianBadge extends StatelessWidget {
  final String noAntrian;
  final String estimasi;

  const _AntrianBadge({required this.noAntrian, required this.estimasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kBlue1, _kBlue2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ANTRIAN ANDA',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(noAntrian,
                    style: const TextStyle(
                      fontSize: 40,
                      color: _kWhite,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    )),
              ],
            ),
          ),
          Container(width: 0.5, height: 50, color: Colors.white30),
          const SizedBox(width: 20),
          Column(
            children: [
              const Text('ESTIMASI',
                  style: TextStyle(
                      fontSize: 10, color: Colors.white70, letterSpacing: 0.8)),
              const SizedBox(height: 4),
              Text(estimasi,
                  style: const TextStyle(
                      fontSize: 14,
                      color: _kWhite,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
