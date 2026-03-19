import 'package:flutter/material.dart';
import '../../dashboard.dart';
import '../../../widgets/struk.dart';

// ─── Theme constants ──────────────────────────────────────────────────────────
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
class UmumTerdaftar extends StatefulWidget {
  const UmumTerdaftar({super.key});

  @override
  State<UmumTerdaftar> createState() => _UmumTerdaftarState();
}

class _UmumTerdaftarState extends State<UmumTerdaftar> {
  final _rmController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode
        .addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _rmController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _showStrukPreview(noAntrian: '45 F');
  }

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
                        Text('Nomor Antrian',
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

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _AntrianBadge(noAntrian: '45 F', estimasi: '± 15 mnt'),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Text(
                  'Silakan menunggu di ruang tunggu. Nomor antrian Anda akan dipanggil melalui layar dan pengeras suara.',
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
                        label: 'Cetak Struk',
                        icon: Icons.print_rounded,
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showStrukPreview(noAntrian: '45 F');
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
    final rm = _rmController.text.trim();
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
              nama: rm.isEmpty ? 'Pengunjung' : rm,
              poli: 'Umum - Terdaftar',
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
            Text('Struk antrian $noAntrian sedang dicetak…',
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
                  Text('Pasien Terdaftar',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _kWhite,
                        letterSpacing: -0.3,
                      )),
                  SizedBox(height: 6),
                  Text('Masukkan No. RM atau NIK Anda untuk mendaftar antrian',
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

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 4),
        const _SectionLabel('IDENTITAS PASIEN'),
        const SizedBox(height: 10),
        _FocusableInputCard(
          controller: _rmController,
          focusNode: _focusNode,
          isFocused: _isFocused,
          label: 'No. Rekam Medis / NIK',
          hint: 'Masukkan No. RM atau NIK',
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 14),
        _buildInfoNote(),
        const SizedBox(height: 32),
        _GradientButton(
          label: 'Daftar Sekarang',
          icon: Icons.check_circle_outline_rounded,
          height: 54,
          fontSize: 15,
          onPressed: _submit,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildInfoNote() {
    return Container(
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
              'Pastikan nomor RM atau NIK yang Anda masukkan sudah benar sebelum submit.',
              style: TextStyle(fontSize: 12, color: _kTextSub, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _FocusableInputCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _FocusableInputCard({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? _kBlue1 : _kNeutral300,
          width: isFocused ? 1.5 : 0.5,
        ),
        boxShadow: isFocused
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
            child: Icon(icon, color: _kWhite, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              style: const TextStyle(
                  fontSize: 14, color: _kText, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: _kTextHint),
                labelText: label,
                labelStyle: const TextStyle(fontSize: 12, color: _kTextSub),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

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
