import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../../dashboard.dart';
import '../../../widgets/struk.dart';

// ─── Theme constants (identik dengan UmumTerdaftar) ───────────────────────────
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
class UmumBelumTerdaftar extends StatefulWidget {
  const UmumBelumTerdaftar({super.key});

  @override
  State<UmumBelumTerdaftar> createState() => _UmumBelumTerdaftarState();
}

class _UmumBelumTerdaftarState extends State<UmumBelumTerdaftar> {
  final _noIdentitasController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _noHpController = TextEditingController();

  String? _jenisKelamin;
  Uint8List? _fotoBytes;
  bool _fotoDemoDiambil = false;

  @override
  void dispose() {
    _noIdentitasController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  Future<void> _ambilFoto() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      await _ambilFotoWindows();
      return;
    }

    if (!_isNativeCameraSupported) {
      final captured = await _showSimulasiKameraDialog();
      if (!mounted || captured != true) return;
      final demoBytes = await _buildDemoCaptureBytes();
      setState(() {
        _fotoBytes = demoBytes;
        _fotoDemoDiambil = true;
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('Kamera tidak tersedia');

      final selectedCamera = cameras
              .where((c) => c.lensDirection == CameraLensDirection.front)
              .isNotEmpty
          ? cameras
              .firstWhere((c) => c.lensDirection == CameraLensDirection.front)
          : cameras.first;

      if (!mounted) return;
      final bytes = await showDialog<Uint8List>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.85),
        builder: (ctx) => _FaceCameraDialog(camera: selectedCamera),
      );

      if (bytes == null || !mounted) return;
      setState(() {
        _fotoBytes = bytes;
        _fotoDemoDiambil = true;
      });
    } on CameraException catch (e) {
      debugPrint('CameraException: ${e.code} ${e.description}');
      final captured = await _showSimulasiKameraDialog(
        pesan: 'Kamera fisik tidak tersedia. Beralih ke kamera simulasi demo.',
      );
      if (!mounted || captured != true) return;
      final demoBytes = await _buildDemoCaptureBytes();
      setState(() {
        _fotoBytes = demoBytes;
        _fotoDemoDiambil = true;
      });
    } catch (_) {
      final captured = await _showSimulasiKameraDialog(
        pesan: 'Perangkat tidak mendukung kamera fisik. Gunakan simulasi demo.',
      );
      if (!mounted || captured != true) return;
      final demoBytes = await _buildDemoCaptureBytes();
      setState(() {
        _fotoBytes = demoBytes;
        _fotoDemoDiambil = true;
      });
    }
  }

  Future<void> _ambilFotoWindows() async {
    final renderer = RTCVideoRenderer();
    MediaStream? stream;

    try {
      await renderer.initialize();
      stream = await navigator.mediaDevices.getUserMedia({
        'audio': false,
        'video': {'facingMode': 'user'},
      });
      renderer.srcObject = stream;
    } catch (_) {
      await renderer.dispose();
      if (!mounted) return;
      final captured = await _showSimulasiKameraDialog(
        pesan: 'Kamera tidak dapat dibuka. Menggunakan kamera simulasi demo.',
      );
      if (!mounted || captured != true) return;
      final demoBytes = await _buildDemoCaptureBytes();
      setState(() {
        _fotoBytes = demoBytes;
        _fotoDemoDiambil = true;
      });
      return;
    }

    final lanjut = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.82,
            child: Stack(
              children: [
                RTCVideoView(renderer),
                Container(color: Colors.black.withOpacity(0.18)),
                Center(
                  child: Container(
                    width: 240,
                    height: 300,
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
                          icon: const Icon(Icons.close_rounded, color: _kWhite),
                        ),
                        const Expanded(
                          child: Text(
                            'Kamera Wajah Pasien',
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
                          'Posisikan wajah di dalam frame, lalu tekan Capture Demo.',
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
      ),
    );

    Uint8List? capturedBytes;
    if (lanjut == true) {
      capturedBytes = await _captureWindowsFrame(renderer, stream);
    }

    stream.getTracks().forEach((track) => track.stop());
    await renderer.dispose();

    if (lanjut == true && mounted) {
      final previewBytes = capturedBytes ?? await _buildDemoCaptureBytes();
      setState(() {
        _fotoBytes = previewBytes;
        _fotoDemoDiambil = true;
      });
    }
  }

  Future<Uint8List?> _captureWindowsFrame(
    RTCVideoRenderer renderer,
    MediaStream? stream,
  ) async {
    try {
      final rendererDynamic = renderer as dynamic;
      final frame = await rendererDynamic.captureFrame();
      final bytes = _extractBytes(frame);
      if (bytes != null && bytes.isNotEmpty) return bytes;
    } catch (_) {}

    try {
      final track = stream?.getVideoTracks().isNotEmpty == true
          ? stream!.getVideoTracks().first
          : null;
      if (track == null) return null;
      final trackDynamic = track as dynamic;
      final frame = await trackDynamic.captureFrame();
      final bytes = _extractBytes(frame);
      if (bytes != null && bytes.isNotEmpty) return bytes;
    } catch (_) {}

    return null;
  }

  Uint8List? _extractBytes(dynamic frame) {
    if (frame == null) return null;
    if (frame is Uint8List) return frame;
    if (frame is ByteBuffer) return frame.asUint8List();
    if (frame is List<int>) return Uint8List.fromList(frame);

    try {
      final dynamic data = (frame as dynamic).data;
      if (data is Uint8List) return data;
      if (data is ByteBuffer) return data.asUint8List();
      if (data is List<int>) return Uint8List.fromList(data);
    } catch (_) {}

    return null;
  }

  Future<Uint8List> _buildDemoCaptureBytes() async {
    const width = 640;
    const height = 800;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, height.toDouble()),
        [const Color(0xFFEAF0FF), const Color(0xFFD8E2FF)],
      );
    canvas.drawRect(rect, bgPaint);

    final frameRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(70, 70, 500, 620),
      const Radius.circular(28),
    );
    canvas.drawRRect(frameRect, Paint()..color = _kWhite.withOpacity(0.9));
    canvas.drawRRect(
      frameRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = _kBlue1.withOpacity(0.25),
    );

    canvas.drawCircle(
      const Offset(320, 300),
      96,
      Paint()..color = _kBlue1.withOpacity(0.18),
    );
    canvas.drawCircle(
      const Offset(320, 295),
      54,
      Paint()..color = _kBlue1.withOpacity(0.35),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(215, 380, 210, 180),
        const Radius.circular(90),
      ),
      Paint()..color = _kBlue1.withOpacity(0.30),
    );

    const titleStyle = TextStyle(
      color: _kText,
      fontSize: 28,
      fontWeight: FontWeight.w700,
    );
    final titlePainter = TextPainter(
      text: const TextSpan(text: 'Captured Demo', style: titleStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    titlePainter.paint(
      canvas,
      Offset((width - titlePainter.width) / 2, 720),
    );

    final image = await recorder.endRecording().toImage(width, height);
    final pngData = await image.toByteData(format: ui.ImageByteFormat.png);
    return pngData!.buffer.asUint8List();
  }

  bool get _isNativeCameraSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<bool?> _showSimulasiKameraDialog({String? pesan}) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.82,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 240,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _kWhite, width: 2.2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white70,
                        size: 82,
                      ),
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
                          icon: const Icon(Icons.close_rounded, color: _kWhite),
                        ),
                        const Expanded(
                          child: Text(
                            'Kamera Wajah (Simulasi Demo)',
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
                        Text(
                          pesan ??
                              'Kamera simulasi aktif. Tekan Capture Demo untuk lanjut alur kiosk.',
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
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _showStrukPreview(noAntrian: '46 F');
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
                child: _AntrianBadge(noAntrian: '46 F', estimasi: '± 15 mnt'),
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
                          _showStrukPreview(noAntrian: '46 F');
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
    final noIdentitas = _noIdentitasController.text.trim();
    final nama = _namaController.text.trim();
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
              nama: nama.isEmpty ? 'Pengunjung' : nama,
              poli: noIdentitas.isEmpty
                  ? 'Umum - Belum Terdaftar'
                  : 'Umum - Belum Terdaftar ($noIdentitas)',
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
                  Text('Pasien Baru',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _kWhite,
                        letterSpacing: -0.3,
                      )),
                  SizedBox(height: 6),
                  Text(
                      'Lengkapi data diri Anda untuk mendapatkan nomor antrian',
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: isWide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 320, child: _buildFotoSection()),
                          const SizedBox(width: 20),
                          Expanded(child: _buildFormSection(isWide: true)),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        _buildFotoSection(),
                        const SizedBox(height: 20),
                        _buildFormSection(isWide: false),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormSection({required bool isWide}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _kNeutral300, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: _kNavy.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelHeader(
            badge: 'DATA DIRI PASIEN',
            title: 'Form Pendaftaran Pasien Baru',
            subtitle:
                'Isi data pasien pada kolom berikut. Pastikan data yang dimasukkan sudah benar untuk memudahkan proses pendaftaran dan pelayanan medis.',
          ),
          const SizedBox(height: 22),
          if (isWide) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatefulInputCard(
                    controller: _noIdentitasController,
                    label: 'NIK',
                    hint: 'Masukkan nomor identitas',
                    icon: Icons.badge_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatefulInputCard(
                    controller: _namaController,
                    label: 'Nama',
                    hint: 'Masukkan nama lengkap',
                    icon: Icons.person_outline_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatefulInputCard(
                    controller: _tempatLahirController,
                    label: 'Tempat Lahir',
                    hint: 'Contoh: Bandung',
                    icon: Icons.location_on_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatefulInputCard(
                    controller: _tanggalLahirController,
                    label: 'Tanggal Lahir',
                    hint: 'Contoh: 12-02-1998',
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatefulInputCard(
                    controller: _noHpController,
                    label: 'No. HP',
                    hint: 'Contoh: 08123456789',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildGenderSelector()),
              ],
            ),
          ] else ...[
            _StatefulInputCard(
              controller: _noIdentitasController,
              label: 'NIK',
              hint: 'Masukkan nomor identitas',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 12),
            _StatefulInputCard(
              controller: _namaController,
              label: 'Nama',
              hint: 'Masukkan nama lengkap',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            _StatefulInputCard(
              controller: _tempatLahirController,
              label: 'Tempat Lahir',
              hint: 'Contoh: Bandung',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 12),
            _StatefulInputCard(
              controller: _tanggalLahirController,
              label: 'Tanggal Lahir',
              hint: 'Contoh: 12-02-1998',
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 12),
            _StatefulInputCard(
              controller: _noHpController,
              label: 'No. HP',
              hint: 'Contoh: 08123456789',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildGenderSelector(),
          ],
          const SizedBox(height: 20),
          _buildInfoNote(),
          const SizedBox(height: 24),
          _GradientButton(
            label: 'Daftar Sekarang',
            icon: Icons.check_circle_outline_rounded,
            height: 54,
            fontSize: 15,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kNeutral300, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_kBlue1, _kBlue2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.wc_rounded, color: _kWhite, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jenis Kelamin',
                  style: TextStyle(fontSize: 11, color: _kTextSub),
                ),
                const SizedBox(height: 8),
                _GenderToggle(
                  value: _jenisKelamin,
                  onChanged: (value) {
                    setState(() => _jenisKelamin = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _kNeutral300, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: _kNavy.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelHeader(
            badge: 'FOTO PASIEN',
            title: 'Verifikasi Wajah',
            subtitle:
                'Ambil foto pasien sebelum menyimpan pendaftaran. Posisi wajah harus jelas dan menghadap ke depan untuk memudahkan proses verifikasi saat berkunjung.',
          ),
          const SizedBox(height: 22),
          Center(
            child: Container(
              width: 220,
              height: 280,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_kNeutral50, _kBlue1.withOpacity(0.08)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _kNeutral100, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _fotoBytes != null
                    ? Image.memory(_fotoBytes!, fit: BoxFit.cover)
                    : Container(
                        color: _kWhite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _kBlue1.withOpacity(0.12),
                                    _kBlue2.withOpacity(0.18),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: _kNeutral500,
                                size: 42,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _fotoDemoDiambil
                                  ? 'Foto demo tersimpan'
                                  : 'Belum ada foto',
                              style: const TextStyle(
                                fontSize: 13,
                                color: _kTextSub,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Ambil foto pasien untuk melengkapi data pendaftaran.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: _kTextHint,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_fotoBytes != null || _fotoDemoDiambil) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                    _fotoBytes != null
                        ? 'Foto berhasil diambil'
                        : 'Foto demo tersimpan',
                    style: const TextStyle(fontSize: 12, color: _kTextSub)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _OutlineButton(
              label: (_fotoBytes != null || _fotoDemoDiambil)
                  ? 'Ambil Ulang Foto'
                  : 'Buka Kamera',
              icon: Icons.camera_alt_rounded,
              onPressed: _ambilFoto,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _kNeutral50,
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
              'Pastikan semua data yang Anda masukkan sudah benar. Data ini akan digunakan untuk keperluan medis.',
              style: TextStyle(fontSize: 12, color: _kTextSub, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaceCameraDialog extends StatefulWidget {
  final CameraDescription camera;

  const _FaceCameraDialog({required this.camera});

  @override
  State<_FaceCameraDialog> createState() => _FaceCameraDialogState();
}

class _FaceCameraDialogState extends State<_FaceCameraDialog> {
  late final CameraController _controller;
  bool _initialized = false;
  bool _capturing = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        _initialized = true;
        _cameraError = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = e.code == 'CameraAccessDenied'
            ? 'Izin kamera ditolak. Mohon izinkan akses kamera.'
            : 'Kamera tidak bisa diinisialisasi di perangkat ini.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Terjadi masalah saat membuka kamera.';
      });
    }
  }

  Future<void> _captureDemo() async {
    if (!_initialized || _capturing) return;
    setState(() => _capturing = true);
    try {
      final file = await _controller.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      Navigator.pop(context, bytes);
    } catch (_) {
      if (!mounted) return;
      setState(() => _capturing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Gagal capture. Silakan coba lagi.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.82,
          child: Stack(
            children: [
              if (_initialized)
                CameraPreview(_controller)
              else if (_cameraError != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _cameraError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _kWhite,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(color: _kWhite),
                ),
              Center(
                child: Container(
                  width: 240,
                  height: 300,
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
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: _kWhite),
                      ),
                      const Expanded(
                        child: Text(
                          'Kamera Wajah Pasien (Demo)',
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
                        'Posisikan wajah pasien di dalam frame, lalu tekan Capture Demo',
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
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: _GradientButton(
                              label:
                                  _capturing ? 'Memproses...' : 'Capture Demo',
                              icon: Icons.camera_alt_rounded,
                              onPressed: _cameraError == null
                                  ? _captureDemo
                                  : _initCamera,
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
  }
}

// ─── Stateful Input Card (self-managed focus) ─────────────────────────────────
class _StatefulInputCard extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _StatefulInputCard({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_StatefulInputCard> createState() => _StatefulInputCardState();
}

class _StatefulInputCardState extends State<_StatefulInputCard> {
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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
            child: Icon(widget.icon, color: _kWhite, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              style: const TextStyle(
                  fontSize: 14, color: _kText, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(fontSize: 13, color: _kTextHint),
                labelText: widget.label,
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

// ─── Shared widgets ───────────────────────────────────────────────────────────

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

class _PanelHeader extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;

  const _PanelHeader({
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(badge),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _kText,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: _kTextSub,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _GenderToggle extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const _GenderToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _kText.withOpacity(0.82),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: _kText.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _GenderToggleOption(
              label: 'Laki-laki',
              selected: value == 'Laki-laki',
              onTap: () => onChanged('Laki-laki'),
            ),
          ),
          Expanded(
            child: _GenderToggleOption(
              label: 'Perempuan',
              selected: value == 'Perempuan',
              onTap: () => onChanged('Perempuan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderToggleOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderToggleOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _kWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? _kText : _kWhite,
          ),
          child: Text(label, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
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
