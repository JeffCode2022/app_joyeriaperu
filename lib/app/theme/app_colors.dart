import 'package:flutter/material.dart';

/// Luxury jewelry color palette — Light theme inspired by champagne, gold & pearl.
abstract final class AppColors {
  // ── Brand ──
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8D48B);
  static const Color goldDark = Color(0xFFB8960C);
  static const Color champagne = Color(0xFFF5E6D3);
  static const Color pearl = Color(0xFFFEFEFA);
  static const Color roseGold = Color(0xFFB76E79);

  // ── Neutrals ──
  static const Color charcoal = Color(0xFF2C2C2E);
  static const Color darkGrey = Color(0xFF3A3A3C);
  static const Color mediumGrey = Color(0xFF8E8E93);
  static const Color lightGrey = Color(0xFFF2F2F7);
  static const Color softGrey = Color(0xFFE5E5EA);
  static const Color white = Color(0xFFFFFFFF);

  // ── Semantic ──
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF5AC8FA);

  // ── Glass ──
  static const Color glassWhite = Color(0x66FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassShadow = Color(0x1A000000);

  // ── Gradients ──
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldLight, gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient champagneGradient = LinearGradient(
    colors: [pearl, champagne],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
