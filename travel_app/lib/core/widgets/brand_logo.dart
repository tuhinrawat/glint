import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable widget for displaying the Glint brand name with the correct font
class BrandLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final bool withTagline;
  
  const BrandLogo({
    super.key, 
    this.fontSize = 24.0,
    this.color,
    this.withTagline = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Glint',
          style: AppTheme.brandFont.copyWith(
            fontSize: fontSize,
            color: color ?? AppTheme.textPrimaryColor,
            letterSpacing: 0.5,
          ),
        ),
        if (withTagline)
          Text(
            'Travel Smarter',
            style: TextStyle(
              fontSize: fontSize * 0.4,
              color: (color ?? AppTheme.textPrimaryColor).withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
      ],
    );
  }
} 