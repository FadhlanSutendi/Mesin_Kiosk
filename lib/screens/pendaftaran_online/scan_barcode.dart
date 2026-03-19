import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../dashboard.dart';
import '../../widgets/struk.dart';

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
class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({super.key});

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  bool _sudahScan = false;
  Map<String, String>? _dataPendaftaran;

  void _setDemoData(String kode) {
    setState(() {
      _sudahScan = true;
      _dataPendaftaran = {
        'kodeBooking': kode,
        'nama': 'Pasien Scan Demo',
        'poli': 'Poli Spesialis Anak',
        'dokter': 'dr. Rian Putra, Sp.A',
        'jadwal': 'Selasa, 10:00',
        'noAntrian': '09 O',
      };
    });
  }

  // ─── Dialog: Kamera scan untuk demo ───────────────────────────────────────
  Future<void> _mulaiScan() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      await _mulaiScanWindows();
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    List<CameraDescription> cameras;

    try {
      cameras = await availableCameras();
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Kamera tidak tersedia di perangkat ini.')),
      );
      return;
    }

    if (cameras.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tidak ada kamera yang terdeteksi.')),
      );
      return;
    }

    final backCameras =
        cameras.where((cam) => cam.lensDirection == CameraLensDirection.back);
    final selectedCamera =
        backCameras.isNotEmpty ? backCameras.first : cameras.first;
    final controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await controller.initialize();
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Gagal membuka kamera. Coba lagi.')),
      );
      await controller.dispose();
      return;
    }

    bool flashOn = false;

    final lanjut = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.82,
                child: Stack(
                  children: [
                    CameraPreview(controller),
                    Container(
                      color: Colors.black.withOpacity(0.18),
                    ),

                    // Overlay frame sederhana agar area scan terlihat jelas.
                    Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _kWhite, width: 2.2),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              icon: const Icon(Icons.close_rounded,
                                  color: _kWhite),
                            ),
                            const Expanded(
                              child: Text(
                                'Camera Scan Barcode',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _kWhite,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final nextMode =
                                    flashOn ? FlashMode.off : FlashMode.torch;
                                try {
                                  await controller.setFlashMode(nextMode);
                                  setModalState(() => flashOn = !flashOn);
                                } catch (_) {
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Flash tidak didukung perangkat ini.'),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                flashOn
                                    ? Icons.flash_off_rounded
                                    : Icons.flash_on_rounded,
                                color: _kWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.62),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Kamera aktif. Arahkan ke barcode lalu tekan Capture Demo.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _kWhite,
                                fontSize: 12,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _OutlineButton(
                                    label: 'Batal',
                                    onPressed: () => Navigator.pop(ctx, false),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: _GradientButton(
                                    label: 'Capture Demo',
                                    icon: Icons.camera_alt_rounded,
                                    onPressed: () => Navigator.pop(ctx, true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    await controller.dispose();

    if (lanjut == true && mounted) {
      final millis = DateTime.now().millisecondsSinceEpoch.toString();
      final kode = 'SCAN-${millis.substring(millis.length - 6)}';
      _setDemoData(kode);
    }
  }

  Future<void> _mulaiScanWindows() async {
    final messenger = ScaffoldMessenger.of(context);
    final renderer = RTCVideoRenderer();
    MediaStream? stream;

    try {
      await renderer.initialize();
      stream = await navigator.mediaDevices.getUserMedia({
        'audio': false,
        'video': {
          'facingMode': 'environment',
        },
      });
      renderer.srcObject = stream;
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Gagal membuka kamera Windows.')),
      );
      await renderer.dispose();
      return;
    }

    final lanjut = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.82,
              child: Stack(
                children: [
                  RTCVideoView(renderer),
                  Container(
                    color: Colors.black.withOpacity(0.18),
                  ),
                  Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _kWhite, width: 2.2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            icon:
                                const Icon(Icons.close_rounded, color: _kWhite),
                          ),
                          const Expanded(
                            child: Text(
                              'Camera Scan Barcode',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _kWhite,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.62),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Kamera Windows aktif. Arahkan ke barcode lalu tekan Capture Demo.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _kWhite,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _OutlineButton(
                                  label: 'Batal',
                                  onPressed: () => Navigator.pop(ctx, false),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: _GradientButton(
                                  label: 'Capture Demo',
                                  icon: Icons.camera_alt_rounded,
                                  onPressed: () => Navigator.pop(ctx, true),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    stream.getTracks().forEach((track) => track.stop());
    await renderer.dispose();

    if (lanjut == true && mounted) {
      final millis = DateTime.now().millisecondsSinceEpoch.toString();
      final kode = 'SCAN-${millis.substring(millis.length - 6)}';
      _setDemoData(kode);
    }
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
                        Text('Tutup',
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
                      _cetakStruk(data['noAntrian'] ?? '-');
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

  void _cetakStruk(String antrian) {
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
            Text('Struk online $antrian sedang dicetak…',
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
                  const Text('Pendaftaran Online',
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
                  Text('Scan Barcode',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _kWhite,
                        letterSpacing: -0.3,
                      )),
                  SizedBox(height: 6),
                  Text(
                      'Arahkan kamera ke barcode pada kartu atau surat booking Anda',
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

        // ── Area scan ──
        _buildScanArea(),

        // ── Kartu info setelah scan berhasil ──
        if (_dataPendaftaran != null) ...[
          const SizedBox(height: 28),
          _buildInfoCard(),
        ],

        const SizedBox(height: 20),
      ],
    );
  }

  // ─── Area scan ────────────────────────────────────────────────────────────
  Widget _buildScanArea() {
    return Container(
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kNeutral100, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Accent line
            Container(height: 3, color: _kNavy),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Viewfinder ilustrasi
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: _kNeutral50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _kNeutral100, width: 0.5),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Corner brackets
                        ..._buildCorners(),
                        // Icon & status
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: _sudahScan
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF16A34A),
                                          Color(0xFF22C55E),
                                        ],
                                      )
                                    : const LinearGradient(
                                        colors: [_kBlue1, _kBlue2],
                                      ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                _sudahScan
                                    ? Icons.check_circle_rounded
                                    : Icons.qr_code_scanner_rounded,
                                color: _kWhite,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _sudahScan ? 'Scan Berhasil' : 'Siap untuk Scan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _sudahScan
                                    ? const Color(0xFF16A34A)
                                    : _kText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _sudahScan
                                  ? 'Data pendaftaran ditemukan'
                                  : 'Ketuk tombol di bawah untuk mulai',
                              style: const TextStyle(
                                  fontSize: 11, color: _kNeutral500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol scan
                  _GradientButton(
                    label: _sudahScan ? 'Scan Ulang' : 'Mulai Scan',
                    icon: _sudahScan
                        ? Icons.refresh_rounded
                        : Icons.qr_code_scanner_rounded,
                    height: 50,
                    onPressed: _mulaiScan,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Corner bracket decorations pada viewfinder
  List<Widget> _buildCorners() {
    const color = _kNeutral300;
    const size = 20.0;
    const thick = 2.5;
    const r = 6.0;

    Widget corner({
      required Alignment align,
      required bool top,
      required bool left,
    }) {
      return Positioned(
        top: top ? 12 : null,
        bottom: top ? null : 12,
        left: left ? 12 : null,
        right: left ? null : 12,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              color: color,
              thick: thick,
              radius: r,
              top: top,
              left: left,
            ),
          ),
        ),
      );
    }

    return [
      corner(align: Alignment.topLeft, top: true, left: true),
      corner(align: Alignment.topRight, top: true, left: false),
      corner(align: Alignment.bottomLeft, top: false, left: true),
      corner(align: Alignment.bottomRight, top: false, left: false),
    ];
  }

  // ─── Kartu info pendaftaran ───────────────────────────────────────────────
  Widget _buildInfoCard() {
    final data = _dataPendaftaran!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('DATA PENDAFTARAN DITEMUKAN'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _kWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kNeutral100, width: 0.5),
          ),
          child: Column(
            children: [
              // Card header navy
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
                      child: const Icon(Icons.qr_code_2_rounded,
                          color: _kWhite, size: 24),
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
                              color: _kWhite,
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
                        gradient:
                            const LinearGradient(colors: [_kBlue1, _kBlue2]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data['noAntrian'] ?? '-',
                        style: const TextStyle(
                            fontSize: 13,
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

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _GradientButton(
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

// ─── Corner bracket painter ───────────────────────────────────────────────────
class _CornerPainter extends CustomPainter {
  final Color color;
  final double thick;
  final double radius;
  final bool top;
  final bool left;

  const _CornerPainter({
    required this.color,
    required this.thick,
    required this.radius,
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    if (top && left) {
      path.moveTo(0, h);
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      path.lineTo(w, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(w - radius, 0);
      path.arcToPoint(Offset(w, radius), radius: Radius.circular(radius));
      path.lineTo(w, h);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, h - radius);
      path.arcToPoint(Offset(radius, h),
          radius: Radius.circular(radius), clockwise: false);
      path.lineTo(w, h);
    } else {
      path.moveTo(0, h);
      path.lineTo(w - radius, h);
      path.arcToPoint(Offset(w, h - radius),
          radius: Radius.circular(radius), clockwise: false);
      path.lineTo(w, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) =>
      old.color != color || old.top != top || old.left != left;
}

// ─── Info row ─────────────────────────────────────────────────────────────────
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

// ─── Struk row ────────────────────────────────────────────────────────────────
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
