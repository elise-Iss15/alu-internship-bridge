import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6C131F);
  static const primaryLight = Color(0xFFA14B58);
  static const secondary = Color(0xFFA14B58);
  static const accent = Color(0xFFC97A85);
  static const background = Color(0xFFFFECEA);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF2B0D11);
  static const textSecondary = Color(0xFF7A5A5E);
  static const success = Color(0xFF3F8F5F);
  static const warning = Color(0xFFC98A3E);
  static const error = Color(0xFFB3261E);
  static const border = Color.fromARGB(255, 1, 0, 0);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C131F), Color(0xFFA14B58)],
  );
}
