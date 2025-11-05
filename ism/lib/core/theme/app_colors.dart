import 'package:flutter/material.dart';

/// App color palette for light and dark themes
class AppColors {
  // Primary Colors (ISM Brand - placeholder, update with actual ISM colors)
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary Colors
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentPink = Color(0xFFE91E63);

  // Subject Colors (for the Four Pillars)
  static const Color economicsColor = Color(0xFF2196F3); // Blue
  static const Color managementColor = Color(0xFF9C27B0); // Purple
  static const Color businessColor = Color(0xFFFF9800); // Orange
  static const Color marketingColor = Color(0xFFE91E63); // Pink

  // Feedback Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);

  // Neutral Colors (Light Theme)
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFBDBDBD);

  // Neutral Colors (Dark Theme)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF424242);

  // Gamification Colors
  static const Color coinGold = Color(0xFFFFD700);
  static const Color gemBlue = Color(0xFF00BCD4);
  static const Color xpGreen = Color(0xFF8BC34A);
  static const Color levelOrange = Color(0xFFFF9800);

  // Badge Rarity Colors
  static const Color commonGray = Color(0xFF9E9E9E);
  static const Color rareBlue = Color(0xFF2196F3);
  static const Color epicPurple = Color(0xFF9C27B0);
  static const Color legendaryGold = Color(0xFFFFD700);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    primaryBlue,
    primaryLight,
  ];

  static const List<Color> successGradient = [
    Color(0xFF66BB6A),
    Color(0xFF4CAF50),
  ];

  static const List<Color> economicsGradient = [
    Color(0xFF42A5F5),
    Color(0xFF2196F3),
  ];

  static const List<Color> managementGradient = [
    Color(0xFFAB47BC),
    Color(0xFF9C27B0),
  ];

  static const List<Color> businessGradient = [
    Color(0xFFFFB74D),
    Color(0xFFFF9800),
  ];

  static const List<Color> marketingGradient = [
    Color(0xFFEC407A),
    Color(0xFFE91E63),
  ];
}
