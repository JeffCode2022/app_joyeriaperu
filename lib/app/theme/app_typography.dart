import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium typography — Playfair Display for headings, Outfit for body.
abstract final class AppTypography {
  // ── Display ──
  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  static TextStyle displaySmall = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  // ── Headlines ──
  static TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineSmall = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // ── Body ──
  static TextStyle bodyLarge = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle bodySmall = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  // ── Labels ──
  static TextStyle labelLarge = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = GoogleFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // ── Special ──
  static TextStyle price = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle priceOld = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle badge = GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );
}
