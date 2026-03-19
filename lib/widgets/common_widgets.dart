import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ─── Label section kecil (e.g. "NOMOR KARTU BPJS") ──────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.neutral500,
        letterSpacing: 1.2,
      ),
    );
  }
}

/// ─── Tombol gradient ─────────────────────────────────────────────────────────
class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final double height;
  final double fontSize;

  const GradientButton({
    super.key,
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
          gradient: AppColors.blueGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue1.withOpacity(0.35),
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
            foregroundColor: AppColors.white,
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

/// ─── Tombol outline ──────────────────────────────────────────────────────────
class OutlineBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? borderColor;

  const OutlineBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.textSub,
          side: BorderSide(color: borderColor ?? AppColors.neutral300, width: 1),
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

/// ─── Badge antrian (pop-up hasil daftar) ─────────────────────────────────────
class AntrianBadge extends StatelessWidget {
  final String noAntrian;
  final String estimasi;

  const AntrianBadge({
    super.key,
    required this.noAntrian,
    required this.estimasi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
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
                      color: AppColors.white,
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
                      color: AppColors.white,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

/// ─── Info note kecil dengan dot indicator ────────────────────────────────────
class InfoNote extends StatelessWidget {
  final String text;
  const InfoNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutral100, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSub, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
