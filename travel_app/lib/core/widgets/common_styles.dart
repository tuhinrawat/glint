import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/color_schemes.dart';

/// A class that provides consistent styling for common UI elements across the app
class CommonStyles {
  // Text Styles - These should be used through Theme.of(context).textTheme instead
  // Only keeping these for backward compatibility
  static TextStyle headingLarge(BuildContext context) => Theme.of(context).textTheme.displayLarge!;
  static TextStyle headingMedium(BuildContext context) => Theme.of(context).textTheme.displayMedium!;
  static TextStyle headingSmall(BuildContext context) => Theme.of(context).textTheme.displaySmall!;
  static TextStyle bodyText(BuildContext context) => Theme.of(context).textTheme.bodyLarge!;
  static TextStyle bodyTextSmall(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle caption(BuildContext context) => Theme.of(context).textTheme.labelSmall!;

  // Trip Card Styles
  static TextStyle tripCardTitle(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle tripCardSubtitle(BuildContext context) => Theme.of(context).textTheme.titleSmall!;
  static TextStyle tripCardMetadata(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle tripCardStatus(BuildContext context) => Theme.of(context).textTheme.labelMedium!.copyWith(
    color: Theme.of(context).colorScheme.onPrimary,
  );
  static TextStyle tripCardAmount(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle tripCardRating(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle tripCardAction(BuildContext context) => Theme.of(context).textTheme.labelMedium!;
  static TextStyle tripCardPayment(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle tripCardPaymentAmount(BuildContext context) => Theme.of(context).textTheme.titleSmall!;

  // Card Styles
  static BoxDecoration cardDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).cardTheme.color,
    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).shadowColor.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
        spreadRadius: -2,
      ),
    ],
  );

  static BoxDecoration sectionDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceSecondary,
    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).shadowColor.withOpacity(0.04),
        blurRadius: 4,
        offset: const Offset(0, 1),
        spreadRadius: -1,
      ),
    ],
  );

  static BoxDecoration elevatedSectionDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.backgroundElevated,
    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).shadowColor.withOpacity(0.12),
        blurRadius: 12,
        offset: const Offset(0, 4),
        spreadRadius: -2,
      ),
    ],
  );

  // Button Styles - These should be used through Theme.of(context).elevatedButtonTheme instead
  // Only keeping these for backward compatibility
  static ButtonStyle primaryButtonStyle(BuildContext context) => Theme.of(context).elevatedButtonTheme.style!;

  static ButtonStyle secondaryButtonStyle(BuildContext context) => ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.surfaceSecondary,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingLarge,
      vertical: AppTheme.spacingMedium,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
    ),
    minimumSize: const Size(0, AppTheme.buttonHeightMedium),
    textStyle: Theme.of(context).textTheme.labelLarge,
  );

  static ButtonStyle textButtonStyle(BuildContext context) => TextButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
    minimumSize: const Size(0, AppTheme.buttonHeightSmall),
    padding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingSmall,
      vertical: AppTheme.spacingXSmall,
    ),
    textStyle: Theme.of(context).textTheme.labelMedium,
  );

  // Input Styles - These should be used through Theme.of(context).inputDecorationTheme instead
  // Only keeping these for backward compatibility
  static InputDecoration inputDecoration(BuildContext context, {
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant,
    );
  }

  // Chip Styles - These should be used through Theme.of(context).chipTheme instead
  static Widget filterChip(BuildContext context, {
    required String label,
    required bool isSelected,
  }) => FilterChip(
    label: Text(label),
    selected: isSelected,
    onSelected: (_) {},
  );

  // Icon Styles
  static Widget iconWithText(BuildContext context, {
    required IconData icon,
    required String text,
    Color? iconColor,
    Color? textColor,
    double? iconSize,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: iconSize ?? AppTheme.iconSizeSmall,
          color: iconColor ?? theme.colorScheme.iconSecondary,
        ),
        const SizedBox(width: AppTheme.spacingXSmall),
        Text(
          text,
          style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
            color: textColor ?? theme.colorScheme.textSecondary,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }

  // Additional Text Styles - These should be used through Theme.of(context).textTheme instead
  static TextStyle sectionTitle(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle sectionSubtitle(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle bookingTitle(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle bookingPrice(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle bookingDetails(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle feedPostTitle(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle feedPostSubtitle(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle feedPostContent(BuildContext context) => Theme.of(context).textTheme.bodyLarge!;
  static TextStyle feedPostMetadata(BuildContext context) => Theme.of(context).textTheme.labelSmall!;
  static TextStyle itineraryHeading(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle itinerarySubheading(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle itineraryDetails(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle itineraryHighlight(BuildContext context) => Theme.of(context).textTheme.titleMedium!.copyWith(
    color: Theme.of(context).colorScheme.primary,
  );
  static TextStyle itineraryOverview(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle itineraryDayTitle(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle itineraryDayDetails(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle formLabel(BuildContext context) => Theme.of(context).textTheme.labelLarge!;
  static TextStyle formHint(BuildContext context) => Theme.of(context).textTheme.labelMedium!;
  static TextStyle budgetAmount(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle budgetLabel(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;
  static TextStyle levelText(BuildContext context) => Theme.of(context).textTheme.labelSmall!;
  static TextStyle preferencesLabel(BuildContext context) => Theme.of(context).textTheme.labelMedium!;

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

  // Section Padding
  static EdgeInsets get sectionPadding => const EdgeInsets.symmetric(
    vertical: AppTheme.spacingLarge,
    horizontal: AppTheme.spacingMedium,
  );

  static EdgeInsets get sectionSpacing => const EdgeInsets.only(
    bottom: AppTheme.spacingLarge,
  );

  // Content grouping without dividers
  static Widget contentGroup({
    required List<Widget> children,
    bool elevated = false,
    BuildContext? context,
  }) {
    return Builder(
      builder: (context) => Container(
        decoration: elevated ? elevatedSectionDecoration(context) : sectionDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        margin: const EdgeInsets.only(bottom: AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children.map((child) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
            child: child,
          )).toList(),
        ),
      ),
    );
  }

  // List item without dividers
  static Widget listItem({
    required Widget child,
    VoidCallback? onTap,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
      decoration: BoxDecoration(
        color: selected 
            ? AppTheme.darkTheme.colorScheme.surfaceSecondary 
            : AppTheme.darkTheme.colorScheme.surfacePrimary,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
              vertical: AppTheme.spacingMedium,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // Badge Style
  static Widget badge({
    required String text,
    Color? backgroundColor,
    Color? textColor,
  }) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingSmall,
      vertical: AppTheme.spacingXSmall,
    ),
    decoration: BoxDecoration(
      color: backgroundColor ?? AppTheme.primaryColor,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: AppTheme.fontSizeSmall,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

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
          style: TextStyle(
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

  // Filter Chip
  static Widget buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
    BuildContext? context,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
    );
  }
} 