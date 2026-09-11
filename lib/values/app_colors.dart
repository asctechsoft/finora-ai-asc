import 'package:flutter/material.dart';

/// Finora design tokens — extracted from the Figma flow.
class AppColors {
  AppColors._();

  // Primary teal
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color primaryDeep = Color(0xFF115E59);
  static const Color primaryTint = Color(0xFFCCFBF1);
  static const Color primaryTintSoft = Color(0xFFE6FBF6);

  // Text
  static const Color heading = Color(0xFF0F172A);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color trackBg = Color(0xFFEEF2F6);

  // Status
  static const Color positive = Color(0xFF10B981);
  static const Color negative = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Category / accent swatches (Figma icons)
  static const Color housing = Color(0xFF3B82F6);
  static const Color food = Color(0xFFEF4444);
  static const Color transport = Color(0xFF0EA5E9);
  static const Color shopping = Color(0xFFF59E0B);
  static const Color entertainment = Color(0xFF8B5CF6);
  static const Color health = Color(0xFF14B8A6);
  static const Color education = Color(0xFF6366F1);
  static const Color other = Color(0xFF94A3B8);
  static const Color income = Color(0xFF10B981);

  // Life-mode accents
  static const Color solo = Color(0xFF0D9488);
  static const Color dating = Color(0xFFEC4899);
  static const Color livingTogether = Color(0xFF0EA5E9);
  static const Color married = Color(0xFF8B5CF6);
  static const Color family = Color(0xFFF59E0B);

  // Hero gradient (Safe-to-Spend card)
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF115E59)],
  );

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
  );

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.05),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}
