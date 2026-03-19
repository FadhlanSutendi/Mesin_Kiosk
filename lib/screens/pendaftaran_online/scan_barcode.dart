import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../dashboard.dart';
import '../../widgets/struk.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/kiosk_navbar.dart';
import '../../widgets/common_widgets.dart';

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
          return Dialog.fullscreen(
            backgroundColor: Colors.black,
            child: Stack(
              fit: StackFit.expand,
                  children: [
                    CameraPreview(controller),

                    // ── Scanner Overlay (Dimming) ──
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ScannerOverlayPainter(
                          scanWidth: 320,
                          scanHeight: 320,
                          borderRadius: 24,
                        ),
                      ),
                    ),

                    // ── Frame Viewfinder ──
                    Center(
                      child: Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: _buildCorners(),
                        ),
                      ),
                    ),

                    // ── Laser Scanning Line ──
                    const _ScanningLine(width: 320, height: 320),

                    // ── Top Controls ──
                    Positioned(
                      top: 15,
                      left: 15,
                      right: 15,
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          children: [
                            _CircularCloseButton(
                                onTap: () => Navigator.pop(ctx, false)),
                            const Expanded(
                              child: Text(
                                'Scan Barcode',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            _CircularCloseButton(
                              icon: flashOn
                                  ? Icons.flash_off_rounded
                                  : Icons.flash_on_rounded,
                              onTap: () async {
                                final nextMode =
                                    flashOn ? FlashMode.off : FlashMode.torch;
                                try {
                                  await controller.setFlashMode(nextMode);
                                  setModalState(() => flashOn = !flashOn);
                                } catch (_) {
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content: Text('Flash tidak didukung.')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Bottom Panel ──
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.6),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Posisikan barcode di dalam kotak pindaian',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlineBtn(
                                    label: 'Batal',
                                    textColor: Colors.white,
                                    borderColor: Colors.white.withOpacity(0.5),
                                    onPressed: () => Navigator.pop(ctx, false),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: GradientButton(
                                    label: 'Ambil Foto',
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
                  ),
                ),
              ],
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
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Stack(
            fit: StackFit.expand,
                children: [
                  RTCVideoView(renderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),

                  // ── Scanner Overlay (Dimming) ──
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ScannerOverlayPainter(
                        scanWidth: 320,
                        scanHeight: 320,
                        borderRadius: 24,
                      ),
                    ),
                  ),

                  // ── Frame Viewfinder ──
                  Center(
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: _buildCorners(),
                      ),
                    ),
                  ),

                  // ── Laser Scanning Line ──
                  const _ScanningLine(width: 320, height: 320),

                  // ── Top Controls ──
                  Positioned(
                    top: 15,
                    left: 15,
                    right: 15,
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          _CircularCloseButton(onTap: () => Navigator.pop(ctx, false)),
                          const Expanded(
                            child: Text(
                              'Scan Barcode',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // Spacer for balance
                        ],
                      ),
                    ),
                  ),

                  // ── Bottom Panel ──
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.6),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Posisikan barcode di dalam kotak pindaian',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Kamera Windows Aktif',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlineBtn(
                                  label: 'Batal',
                                  textColor: Colors.white,
                                  borderColor: Colors.white.withOpacity(0.5),
                                  onPressed: () => Navigator.pop(ctx, false),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: GradientButton(
                                  label: 'Ambil Foto',
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
                ),
              ),
            ],
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
                title: 'Scan Barcode',
                subtitle:
                    'Arahkan kamera ke barcode pada kartu atau surat booking Anda',
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral100, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Accent line
            Container(height: 3, color: AppColors.navy),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Viewfinder ilustrasi
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.neutral100, width: 0.5),
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
                                    : AppColors.blueGradient,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                _sudahScan
                                    ? Icons.check_circle_rounded
                                    : Icons.qr_code_scanner_rounded,
                                color: AppColors.white,
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
                                    : AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _sudahScan
                                  ? 'Data pendaftaran ditemukan'
                                  : 'Ketuk tombol di bawah untuk mulai',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.neutral500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol scan
                  GradientButton(
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
    const color = AppColors.neutral300;
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
                      child: const Icon(Icons.qr_code_2_rounded,
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

// ─── Corner bracket painter ───────────────────────────────────────────────────
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

// ─── Scanner Overlay Painter ──────────────────────────────────────────────────
/// Meredupkan area di luar viewfinder (crop area)
class _ScannerOverlayPainter extends CustomPainter {
  final double scanWidth;
  final double scanHeight;
  final double borderRadius;

  _ScannerOverlayPainter({
    required this.scanWidth,
    required this.scanHeight,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);

    // Path untuk seluruh area
    final fullPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Path untuk viewfinder (tengah)
    final left = (size.width - scanWidth) / 2;
    final top = (size.height - scanHeight) / 2;
    final viewfinderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, scanWidth, scanHeight),
      Radius.circular(borderRadius),
    );
    final viewfinderPath = Path()..addRRect(viewfinderRect);

    // Kombinasi (Subtract viewfinder from background)
    final path = Path.combine(PathOperation.difference, fullPath, viewfinderPath);

    canvas.drawPath(path, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Scanning Line Widget ─────────────────────────────────────────────────────
class _ScanningLine extends StatefulWidget {
  final double width;
  final double height;
  const _ScanningLine({required this.width, required this.height});

  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: (MediaQuery.of(context).size.height - widget.height) / 2 +
              (_controller.value * widget.height),
          left: (MediaQuery.of(context).size.width - widget.width) / 2,
          child: Container(
            width: widget.width,
            height: 2,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.0),
                  Colors.red,
                  Colors.red.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
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

// ─── Tombol bulat transparan ──────────────────────────────────────────────────
class _CircularCloseButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const _CircularCloseButton({
    required this.onTap,
    this.icon = Icons.close_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
