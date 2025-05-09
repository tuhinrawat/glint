import 'package:flutter/material.dart';

/// Extension on ColorScheme to add custom semantic colors
extension CustomColorScheme on ColorScheme {
  // Semantic Background Colors
  Color get backgroundPrimary => brightness == Brightness.dark 
      ? const Color(0xFF1C1C23) 
      : const Color(0xFFFAFAFA);
  
  Color get backgroundSecondary => brightness == Brightness.dark
      ? const Color(0xFF282830)
      : const Color(0xFFF5F5F5);
      
  Color get backgroundElevated => brightness == Brightness.dark
      ? const Color(0xFF1E1E24)
      : const Color(0xFFFAFAFA);

  // Semantic Surface Colors
  Color get surfacePrimary => brightness == Brightness.dark
      ? const Color(0xFF1C1C23)  // Dark charcoal
      : const Color(0xFFFFFFFF);  // Pure white
      
  Color get surfaceSecondary => brightness == Brightness.dark
      ? const Color(0xFF282830)  // Slightly lighter charcoal
      : const Color(0xFFF5F5F5);  // Light gray

  Color get surfaceTertiary => brightness == Brightness.dark
      ? const Color(0xFF32323A)  // Even lighter charcoal
      : const Color(0xFFEBEBEB);  // Lighter gray

  // Brand Colors
  Color get brandPrimary => const Color(0xFF3498DB);  // Bright Blue
  Color get brandSecondary => brightness == Brightness.dark
      ? const Color(0xFF1ABC9C)  // Bright Teal
      : const Color(0xFF16A085);  // Darker Teal
  
  // Accent Colors
  Color get accent1 => const Color(0xFF9B59B6);  // Purple
  Color get accent2 => const Color(0xFF1ABC9C);  // Teal
  Color get accent3 => const Color(0xFF3498DB);  // Blue
  Color get accent4 => const Color(0xFF8E44AD);  // Dark Purple

  // Text Colors
  Color get textPrimary => brightness == Brightness.dark
      ? const Color(0xFFFFFFFF)  // Pure white
      : const Color(0xFF1C1C23);  // Dark charcoal
      
  Color get textSecondary => brightness == Brightness.dark
      ? const Color(0xFFAAAAAA)  // Light gray
      : const Color(0xFF666666);  // Dark gray
      
  Color get textTertiary => brightness == Brightness.dark
      ? const Color(0xFF666666)
      : const Color(0xFF8F8F8F);

  // Status Colors
  Color get success => const Color(0xFF1ABC9C);  // Teal
  Color get warning => const Color(0xFFF1C40F);  // Yellow
  Color get error => const Color(0xFFE74C3C);    // Crimson
  Color get info => const Color(0xFF3498DB);     // Blue

  // Interactive Colors
  Color get interactive => brightness == Brightness.dark
      ? const Color(0xFF3498DB)  // Bright Blue
      : const Color(0xFF2980B9);  // Darker Blue
  Color get interactiveHover => primary.withOpacity(0.9);
  Color get interactivePressed => primary.withOpacity(0.8);
  Color get interactiveDisabled => onSurface.withOpacity(0.38);

  // Icon Colors
  Color get iconPrimary => brightness == Brightness.dark
      ? const Color(0xFFFFFFFF)  // Pure white
      : const Color(0xFF1C1C23);  // Dark charcoal
  Color get iconSecondary => brightness == Brightness.dark
      ? const Color(0xFFAAAAAA)  // Light gray
      : const Color(0xFF666666);  // Dark gray
  Color get iconActive => brightness == Brightness.dark
      ? const Color(0xFF7B6EF6)  // Modern purple
      : const Color(0xFF6B5EE6);  // Slightly darker purple
  Color get iconInactive => brightness == Brightness.dark
      ? const Color(0xFF666666)  // Dark gray
      : const Color(0xFFAAAAAA);  // Light gray
  Color get iconSuccess => brightness == Brightness.dark
      ? const Color(0xFF4CD471)  // Mint green
      : const Color(0xFF3CC461);  // Slightly darker mint
  Color get iconWarning => warning;  // Warning-related icons
  Color get iconError => brightness == Brightness.dark
      ? const Color(0xFFFF8FA3)  // Soft pink
      : const Color(0xFFFF7F93);  // Slightly darker pink
  Color get iconInfo => info;  // Info-related icons

  // Border Colors
  Color get borderPrimary => brightness == Brightness.dark
      ? const Color(0xFF32323A)  // Light charcoal
      : const Color(0xFFE0E0E0);  // Light gray
      
  Color get borderSecondary => brightness == Brightness.dark
      ? Colors.white.withOpacity(0.05)
      : Colors.black.withOpacity(0.05);
}

extension ChartColors on ColorScheme {
  List<Color> get chartColors => [
    primary,        // Primary brand color
    secondary,      // Secondary brand color
    tertiary,       // Tertiary brand color
    accent1,        // Pink accent
    accent2,        // Yellow accent
    accent3,        // Green accent
    accent4,        // Purple accent
    error,          // Error color
    surfaceVariant,  // Surface variant
    inverseSurface,  // Inverse surface
  ];

  Color getChartColor(int index) => chartColors[index % chartColors.length];
}

/// Light Color Scheme
final lightColorScheme = ColorScheme.light(
  primary: const Color(0xFF2D3E50),      // Deep Blue
  primaryContainer: const Color(0xFF3498DB),  // Bright Blue
  secondary: const Color(0xFF16A085),     // Teal
  secondaryContainer: const Color(0xFF1ABC9C),  // Bright Teal
  tertiary: const Color(0xFF8E44AD),      // Royal Purple
  tertiaryContainer: const Color(0xFF9B59B6),  // Bright Purple
  surface: Colors.white,
  background: Colors.white,
  error: const Color(0xFFE74C3C),         // Crimson
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onTertiary: Colors.white,
  onSurface: const Color(0xFF2C3E50),     // Dark Blue-Gray
  onBackground: const Color(0xFF2C3E50),
  onError: Colors.white,
  brightness: Brightness.light,
);

/// Dark Color Scheme
final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: const Color(0xFF3498DB),      // Bright Blue
  onPrimary: Colors.white,
  primaryContainer: const Color(0xFF2980B9),  // Darker Blue
  onPrimaryContainer: Colors.white,
  secondary: const Color(0xFF1ABC9C),     // Bright Teal
  onSecondary: Colors.white,
  secondaryContainer: const Color(0xFF16A085),  // Darker Teal
  onSecondaryContainer: Colors.white,
  tertiary: const Color(0xFF9B59B6),      // Bright Purple
  onTertiary: Colors.white,
  tertiaryContainer: const Color(0xFF8E44AD),  // Darker Purple
  onTertiaryContainer: Colors.white,
  error: const Color(0xFFE74C3C),         // Crimson
  onError: Colors.white,
  errorContainer: const Color(0xFFC0392B),  // Darker Crimson
  onErrorContainer: Colors.white,
  background: const Color(0xFF1A1A2E),    // Deep Navy
  onBackground: Colors.white,
  surface: const Color(0xFF16213E),       // Navy Blue
  onSurface: Colors.white,
  surfaceVariant: const Color(0xFF0F3460),  // Rich Navy
  onSurfaceVariant: const Color(0xFFE5E5E5),  // Light Gray
  outline: const Color(0xFF4A5568),       // Blue Gray
  outlineVariant: const Color(0xFF2D3748),  // Darker Blue Gray
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Colors.white,
  onInverseSurface: const Color(0xFF1A1A2E),  // Deep Navy
  inversePrimary: const Color(0xFF2980B9),  // Darker Blue
  surfaceTint: const Color(0xFF3498DB),   // Bright Blue
); 