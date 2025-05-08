import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A class that provides consistent styling for common UI elements across the app
class CommonStyles {
  // Text Styles
  static TextStyle get headingLarge => const TextStyle(
        fontSize: AppTheme.fontSizeXXLarge,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimaryColor,
      );

  static TextStyle get headingMedium => const TextStyle(
        fontSize: AppTheme.fontSizeXLarge,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimaryColor,
      );

  static TextStyle get headingSmall => const TextStyle(
        fontSize: AppTheme.fontSizeLarge,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimaryColor,
      );

  static TextStyle get bodyText => const TextStyle(
        fontSize: AppTheme.fontSizeMedium,
        color: AppTheme.textPrimaryColor,
      );

  static TextStyle get bodyTextSmall => const TextStyle(
        fontSize: AppTheme.fontSizeSmall,
        color: AppTheme.textPrimaryColor,
      );

  static TextStyle get caption => const TextStyle(
        fontSize: AppTheme.fontSizeXSmall,
        color: AppTheme.textSecondaryColor,
      );

  // Card Styles
  static BoxDecoration get cardDecoration => AppTheme.cardBoxDecoration;

  static BoxDecoration get highlightedCardDecoration => AppTheme.highlightedCardBoxDecoration;

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, AppTheme.buttonHeightMedium),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLarge,
          vertical: AppTheme.spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: AppTheme.fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
      );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textPrimaryColor,
        minimumSize: const Size(0, AppTheme.buttonHeightMedium),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLarge,
          vertical: AppTheme.spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        side: const BorderSide(color: AppTheme.textSecondaryColor, width: 1),
        textStyle: const TextStyle(
          fontSize: AppTheme.fontSizeSmall,
          fontWeight: FontWeight.w500,
        ),
      );

  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
        foregroundColor: AppTheme.primaryColor,
        minimumSize: const Size(0, AppTheme.buttonHeightSmall),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingSmall,
          vertical: AppTheme.spacingXSmall,
        ),
        textStyle: const TextStyle(
          fontSize: AppTheme.fontSizeSmall,
          fontWeight: FontWeight.w500,
        ),
      );

  // Input Styles
  static InputDecoration inputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppTheme.surfaceColor,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppTheme.textTertiaryColor,
        fontSize: AppTheme.fontSizeSmall,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        borderSide: const BorderSide(
          color: AppTheme.primaryColor,
          width: 1,
        ),
      ),
    );
  }

  // Tag/Chip Styles
  static ChipThemeData get chipThemeData => ChipThemeData(
        backgroundColor: AppTheme.surfaceColor.withOpacity(0.3),
        disabledColor: AppTheme.surfaceColor.withOpacity(0.1),
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        secondarySelectedColor: AppTheme.secondaryColor.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingSmall,
          vertical: 0,
        ),
        labelStyle: const TextStyle(
          fontSize: AppTheme.fontSizeXSmall,
          color: AppTheme.textPrimaryColor,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: AppTheme.fontSizeXSmall,
          color: AppTheme.secondaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        ),
      );

  // Filter Chip Style
  static Chip buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: AppTheme.fontSizeXSmall,
        ),
      ),
      backgroundColor: isSelected
          ? AppTheme.primaryColor.withOpacity(0.1)
          : AppTheme.surfaceColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        side: BorderSide.none,
      ),
    );
  }
  
  // Icon Styles
  static Widget iconWithText({
    required IconData icon,
    required String text,
    Color? iconColor,
    Color? textColor,
    double? iconSize,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: iconSize ?? AppTheme.iconSizeSmall,
          color: iconColor ?? AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: AppTheme.spacingXSmall),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? AppTheme.fontSizeXSmall,
            color: textColor ?? AppTheme.textSecondaryColor,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Badge Style
  static Widget badge({
    required String text,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        border: null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: AppTheme.fontSizeXSmall,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Search Bar Style
  static Widget searchBar({
    required TextEditingController controller,
    required String hintText,
    Function(String)? onChanged,
    Function()? onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40, // Fixed height to prevent overflow
      decoration: AppTheme.searchBarDecoration,
      child: Center(
        child: TextField(
          controller: controller,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor, 
            fontSize: AppTheme.fontSizeSmall
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.search,
                color: Colors.grey.shade400,
                size: AppTheme.iconSizeSmall,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: AppTheme.fontSizeSmall,
            ),
            border: InputBorder.none,
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: AppTheme.iconSizeSmall),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      controller.clear();
                      if (onClear != null) onClear();
                      if (onChanged != null) onChanged('');
                    },
                  )
                : null,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Standard Padding
  static EdgeInsets get standardPadding => const EdgeInsets.all(AppTheme.spacingLarge);
  static EdgeInsets get mediumPadding => const EdgeInsets.all(AppTheme.spacingMedium);
  static EdgeInsets get smallPadding => const EdgeInsets.all(AppTheme.spacingSmall);
  
  // Card Content Padding
  static EdgeInsets get cardContentPadding => const EdgeInsets.all(AppTheme.spacingMedium);
  
  // List Item Padding
  static EdgeInsets get listItemPadding => const EdgeInsets.symmetric(
    horizontal: AppTheme.spacingLarge,
    vertical: AppTheme.spacingMedium,
  );
} 