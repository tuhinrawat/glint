import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF7F5AF0);
  static const Color secondaryColor = Color(0xFF2CB67D);
  static const Color backgroundColor = Color(0xFF181A20);
  static const Color surfaceColor = Color(0xFF23243B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);

  // Text Colors
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFB0B0B0);
  static const Color textTertiaryColor = Color(0xFF808080);

  // Brand Typography
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

  // Component Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Spacing & Padding
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 24.0;

  // Component Heights
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 40.0;
  static const double buttonHeightLarge = 48.0;
  static const double inputHeight = 42.0;
  static const double chipHeight = 28.0;

  // Typography Scale
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeDisplay = 24.0;

  // Shadows
  static List<BoxShadow> get defaultShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // Create the base theme
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: surfaceColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeDisplay,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeXXLarge,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        displaySmall: TextStyle(
          fontSize: fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleSmall: TextStyle(
          fontSize: fontSizeXSmall,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeMedium,
          color: textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeSmall,
          color: textPrimaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: fontSizeXSmall,
          color: textSecondaryColor,
        ),
        labelLarge: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: fontSizeXSmall,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        labelSmall: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingSmall,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: textTertiaryColor,
          fontSize: fontSizeSmall,
        ),
        prefixIconColor: textSecondaryColor,
        suffixIconColor: textSecondaryColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        iconTheme: IconThemeData(
          color: textPrimaryColor,
          size: iconSizeMedium,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: const TextStyle(
          fontSize: fontSizeXSmall,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: fontSizeXSmall,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: primaryColor.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                color: primaryColor,
                fontSize: fontSizeXSmall,
                fontWeight: FontWeight.w500,
              );
            }
            return const TextStyle(
              color: textSecondaryColor,
              fontSize: fontSizeXSmall,
            );
          },
        ),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(
                color: primaryColor,
                size: iconSizeMedium,
              );
            }
            return const IconThemeData(
              color: textSecondaryColor,
              size: iconSizeMedium,
            );
          },
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, buttonHeightMedium),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeSmall,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(0, buttonHeightSmall),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingSmall,
            vertical: spacingXSmall,
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeSmall,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryColor,
          backgroundColor: surfaceColor.withOpacity(0.3),
          minimumSize: const Size(0, buttonHeightMedium),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
            side: BorderSide.none,
          ),
          side: BorderSide.none,
          textStyle: const TextStyle(
            fontSize: fontSizeSmall,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor.withOpacity(0.3),
        disabledColor: surfaceColor.withOpacity(0.1),
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: secondaryColor.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSmall,
          vertical: 0,
        ),
        labelStyle: const TextStyle(
          fontSize: fontSizeXSmall,
          color: textPrimaryColor,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: fontSizeXSmall,
          color: secondaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          side: BorderSide.none,
        ),
        side: BorderSide.none,
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2C3F),
        thickness: 1,
        space: spacingLarge,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor,
        indicatorColor: primaryColor,
        labelStyle: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        circularTrackColor: Color(0xFF2A2C3F),
        linearTrackColor: Color(0xFF2A2C3F),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
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