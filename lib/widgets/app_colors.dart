import 'package:flutter/material.dart';

/// ─── Palet warna global untuk seluruh aplikasi ──────────────────────────────
class AppColors {
  AppColors._();

  // Primary navy & blues
  static const Color navy       = Color(0xFF00155E);
  static const Color navy2      = Color(0xFF001A6E);
  static const Color blue1      = Color(0xFF0D3B9E);
  static const Color blue2      = Color(0xFF1E56D0);
  static const Color accentBlue = Color(0xFF2966F4);

  // Neutrals
  static const Color neutral50  = Color(0xFFF4F6FA);
  static const Color neutral100 = Color(0xFFEAEDF3);
  static const Color neutral300 = Color(0xFFCDD1DC);
  static const Color neutral500 = Color(0xFF8A90A0);

  // Text
  static const Color text       = Color(0xFF00155E);
  static const Color textSub    = Color(0xFF5A6070);
  static const Color textHint   = Color(0xFFB0B5C0);

  // Surface
  static const Color white      = Colors.white;
  static const Color background = Color(0xFFF4F6FA);

  // Gradient presets
  static const LinearGradient navyGradient = LinearGradient(
    colors: [navy, navy2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [blue1, blue2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
