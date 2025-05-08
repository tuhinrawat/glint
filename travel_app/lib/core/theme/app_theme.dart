import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'color_schemes.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF7B6EF6);  // Modern purple
  static const Color secondaryColor = Color(0xFF4CD471);  // Mint green
  static const Color backgroundColor = Color(0xFF1C1C23);  // Dark charcoal
  static const Color surfaceColor = Color(0xFF282830);    // Slightly lighter charcoal
  static const Color errorColor = Color(0xFFFF8FA3);      // Soft pink
  static const Color warningColor = Color(0xFFFFB84C);    // Warm yellow

  // Additional Colors
  static const Color accentPink = Color(0xFFFF8FA3);
  static const Color accentYellow = Color(0xFFFFB84C);
  static const Color accentPurple = Color(0xFF7B6EF6);
  static const Color accentGreen = Color(0xFF4CD471);

  // Text Colors
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFAAAAAA);  // Light gray
  static const Color textTertiaryColor = Color(0xFF666666);   // Dark gray

  // Platform-specific base font size
  static double get _baseFontSize => Platform.isIOS ? 16.0 : 16.0;

  // Brand Typography (keeping KumbhSans for brand elements)
  static TextStyle get brandFont => GoogleFonts.kumbhSans(
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static TextStyle get brandFontLarge => GoogleFonts.kumbhSans(
    fontWeight: FontWeight.bold,
    fontSize: fontSizeDisplay,
    color: textPrimaryColor,
    letterSpacing: 0.5,
  );
  
  static TextStyle get brandFontMedium => GoogleFonts.kumbhSans(
    fontWeight: FontWeight.bold,
    fontSize: fontSizeXLarge,
    color: textPrimaryColor,
    letterSpacing: 0.5,
  );
  
  static TextStyle get brandFontSmall => GoogleFonts.kumbhSans(
    fontWeight: FontWeight.bold,
    fontSize: fontSizeLarge,
    color: textPrimaryColor,
    letterSpacing: 0.5,
  );

  // Typography Scale (relative to base font size)
  static double get fontSizeXSmall => _baseFontSize * 0.75;   // 12pt/px
  static double get fontSizeSmall => _baseFontSize * 0.875;   // 14pt/px
  static double get fontSizeMedium => _baseFontSize;          // 16pt/px
  static double get fontSizeLarge => _baseFontSize * 1.125;   // 18pt/px
  static double get fontSizeXLarge => _baseFontSize * 1.25;   // 20pt/px
  static double get fontSizeXXLarge => _baseFontSize * 1.5;   // 24pt/px
  static double get fontSizeDisplay => _baseFontSize * 2.0;   // 32pt/px

  // Component Sizes
  static const double iconSizeXSmall = 14.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;

  // Spacing & Padding
  static const double spacingXXSmall = 4.0;
  static const double spacingXSmall = 8.0;
  static const double spacingSmall = 12.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 40.0;

  // Component Heights
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 40.0;
  static const double buttonHeightLarge = 48.0;
  static const double inputHeight = 48.0;
  static const double chipHeight = 32.0;

  // Shadows
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  // Create the base theme
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.dark(
      primary: const Color(0xFFE67E22), // Deep Saffron
      secondary: const Color(0xFFFFB300), // Golden Amber
      error: const Color(0xFFD32F2F), // Crimson Red
      background: const Color(0xFF212121), // Dark Slate
      surface: const Color(0xFF2E2E2E), // Charcoal Gray
      onPrimary: const Color(0xFFECEFF1), // Off-White
      onSecondary: const Color(0xFFECEFF1), // Off-White
      onBackground: const Color(0xFFECEFF1), // Off-White
      onSurface: const Color(0xFFECEFF1), // Off-White
      onError: const Color(0xFFECEFF1), // Off-White
      primaryContainer: const Color(0xFF2E7D32), // Dark Teal
      outline: const Color(0xFFB0BEC5), // Soft Gray
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colorScheme.background,

      // Typography
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFFECEFF1), // Off-White
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFECEFF1),
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFECEFF1),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFFECEFF1),
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF78909C), // Light Gray
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFECEFF1), // Off-White for button text
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primaryContainer,
          side: BorderSide(color: colorScheme.primaryContainer),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Field Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        hintStyle: TextStyle(color: const Color(0xFF78909C)), // Light Gray
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.primaryContainer,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),

      // Additional Settings
      visualDensity: VisualDensity.adaptivePlatformDensity,
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
    );
  }

  // Light theme
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.light(
      primary: const Color(0xFFFF8C66), // Soft Saffron
      secondary: const Color(0xFFFFD54F), // Warm Yellow
      error: const Color(0xFFFF6B6B), // Coral Red
      background: const Color(0xFFF5F7FA), // Off-White
      surface: const Color(0xFFFFFFFF), // White
      onPrimary: const Color(0xFFFFFFFF), // White
      onSecondary: const Color(0xFF4A4A4A), // Dark Gray
      onBackground: const Color(0xFF4A4A4A), // Dark Gray
      onSurface: const Color(0xFF4A4A4A), // Dark Gray
      onError: const Color(0xFFFFFFFF), // White
      primaryContainer: const Color(0xFF4DB6AC), // Teal Blue
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colorScheme.background,
      
      // Typography
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A4A4A), // Dark Gray
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A4A4A),
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A4A4A),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFF4A4A4A),
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB0B0B0), // Medium Gray
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF), // White for button text
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primaryContainer,
          side: BorderSide(color: colorScheme.primaryContainer),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Field Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.primaryContainer,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
      ),

      // Additional Settings
      visualDensity: VisualDensity.adaptivePlatformDensity,
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
    );
  }

  // Component-specific styles
  static BoxDecoration get cardBoxDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        boxShadow: defaultShadow,
        border: null,
      );

  static BoxDecoration get highlightedCardBoxDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        boxShadow: defaultShadow,
        border: null,
      );

  static BoxDecoration get searchBarDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
      );

  static EdgeInsets get standardCardPadding => const EdgeInsets.all(spacingMedium);
  static EdgeInsets get standardScreenPadding => const EdgeInsets.all(spacingLarge);
} 

