import 'package:flutter/material.dart';

/// App color palette based on water/aqua theme
class AppColors {
  AppColors._();

  // Primary Water Colors
  static const Color primary = Color(0xFF0EA5E9); // Sky blue
  static const Color primaryLight = Color(0xFF38BDF8); // Light blue
  static const Color primaryDark = Color(0xFF0284C7); // Deep blue
  
  // Secondary Aqua Colors
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color accent = Color(0xFF22D3EE); // Bright cyan
  static const Color waterBlue = Color(0xFF3B82F6); // Water blue
  
  // Background Colors
  static const Color background = Color(0xFFF0F9FF); // Very light blue
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFE0F2FE); // Light blue tint
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0C4A6E);
  static const Color darkSurface = Color(0xFF075985);
  static const Color darkCard = Color(0xFF0369A1);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0C4A6E);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue
  
  // Water Progress Colors
  static const Color progressEmpty = Color(0xFFE0F2FE);
  static const Color progressFilled = Color(0xFF0EA5E9);
  static const Color progressExceeded = Color(0xFF22D3EE);
  
  // Gradient Colors
  static const LinearGradient waterGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient waveGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFE0F2FE),
      Color(0xFFBAE6FD),
      Color(0xFFE0F2FE),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Other Colors
  static const Color divider = Color(0xFFBAE6FD);
  static const Color shadow = Color(0x1A0EA5E9);
  static const Color overlay = Color(0x80000000);
  
  // Achievement Colors
  static const Color achievementGold = Color(0xFFFBBF24);
  static const Color achievementSilver = Color(0xFFD1D5DB);
  static const Color achievementBronze = Color(0xFFF97316);
  
  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF0EA5E9),
    Color(0xFF06B6D4),
    Color(0xFF22D3EE),
    Color(0xFF38BDF8),
    Color(0xFF7DD3FC),
  ];
}
