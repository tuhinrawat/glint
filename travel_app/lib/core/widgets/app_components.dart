import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_theme.dart';
import 'common_styles.dart';
import '../services/currency_service.dart';

/// A collection of reusable UI components styled consistently for the app
class AppComponents {
  /// Standard circular loading indicator
  static Widget loadingIndicator({
    double size = 40,
    Color? color,
  }) {
    return SpinKitFadingCircle(
      color: color ?? AppTheme.primaryColor,
      size: size,
    );
  }

  /// Standard cached image with loading placeholder and error handling
  static Widget cachedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? Center(
        child: loadingIndicator(size: 24),
      ),
      errorWidget: (context, url, error) => errorWidget ?? Container(
        color: Colors.grey.shade800,
        child: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Standard card with image, title, and description
  static Widget imageCard({
    required String imageUrl,
    required String title,
    String? subtitle,
    String? label,
    VoidCallback? onTap,
    double height = 160,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: double.infinity,
          decoration: CommonStyles.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      cachedImage(imageUrl: imageUrl),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: AppTheme.spacingMedium,
                        left: AppTheme.spacingMedium,
                        right: AppTheme.spacingMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: CommonStyles.headingSmall(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: AppTheme.spacingXSmall),
                              Text(
                                subtitle,
                                style: CommonStyles.caption(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (label != null)
                        Positioned(
                          top: AppTheme.spacingSmall,
                          right: AppTheme.spacingSmall,
                          child: CommonStyles.badge(text: label),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Standard filter chip list
  static Widget filterChipList({
    required List<String> options,
    required String selectedOption,
    required Function(String) onSelected,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 8.0),
  }) {
    return Container(
      height: AppTheme.chipHeight + AppTheme.spacingSmall * 2,
      padding: padding,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedOption;
          return Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingSmall),
            child: CommonStyles.buildFilterChip(
              label: option,
              isSelected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
            ),
          );
        },
      ),
    );
  }

  /// Section title with optional "View All" button
  static Widget sectionTitle({
    required String title,
    VoidCallback? onViewAll,
    String viewAllText = 'View All',
  }) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spacingLarge,
          AppTheme.spacingLarge,
          AppTheme.spacingLarge,
          AppTheme.spacingSmall,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: CommonStyles.headingSmall(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onViewAll != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: onViewAll,
                  style: CommonStyles.textButtonStyle(context),
                  child: Text(viewAllText),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Standard search bar
  static Widget searchBar({
    required TextEditingController controller,
    required String hintText,
    Function(String)? onChanged,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingLarge,
      vertical: AppTheme.spacingSmall,
    ),
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          margin: margin,
          height: 40,
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMedium,
                vertical: AppTheme.spacingSmall,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }
    );
  }

  /// Icon with label
  static Widget iconLabel({
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: AppTheme.fontSizeSmall,
          ),
        ),
      ],
    );
  }

  /// Rating display with stars
  static Widget ratingDisplay(
    double rating, {
    Color starColor = Colors.amber,
    double starSize = AppTheme.iconSizeSmall,
    bool showText = true,
    Color? textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          color: starColor,
          size: starSize,
        ),
        const SizedBox(width: AppTheme.spacingXSmall),
        if (showText)
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: AppTheme.fontSizeXSmall,
              color: textColor ?? AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  /// Price display
  static Widget priceDisplay(
    double amount, {
    double? fontSize,
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    Currency? fromCurrency,
  }) {
    return Text(
      CurrencyService.formatAmount(amount, from: fromCurrency),
      style: TextStyle(
        fontSize: fontSize ?? AppTheme.fontSizeMedium,
        color: color ?? AppTheme.textPrimaryColor,
        fontWeight: fontWeight,
      ),
    );
  }

  /// Horizontal destinations list with consistent styling
  static Widget horizontalDestinationsList({
    required List<Map<String, dynamic>> destinations,
    required Function(String) onDestinationSelected,
    String? selectedDestination,
    double height = 150,
  }) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLarge,
          vertical: AppTheme.spacingXSmall,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          final isSelected = destination['name'] == selectedDestination;
          
          return GestureDetector(
            onTap: () => onDestinationSelected(destination['name']),
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: AppTheme.spacingSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                border: isSelected ? Border.all(
                  color: AppTheme.primaryColor,
                  width: 1.5,
                ) : null,
                boxShadow: AppTheme.defaultShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    cachedImage(imageUrl: destination['image']),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: AppTheme.spacingSmall,
                      left: AppTheme.spacingSmall,
                      right: AppTheme.spacingSmall,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination['name'],
                            style: TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: AppTheme.fontSizeSmall,
                            ),
                          ),
                          Text(
                            destination['subtitle'],
                            style: TextStyle(
                              color: AppTheme.textPrimaryColor.withOpacity(0.8),
                              fontSize: AppTheme.fontSizeXSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// Tag list (horizontal)
  static Widget tagList(
    List<String> tags, {
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 8.0),
  }) {
    return Wrap(
      spacing: AppTheme.spacingSmall,
      runSpacing: AppTheme.spacingSmall,
      children: tags.map((tag) => Chip(
        label: Text(
          tag,
          style: TextStyle(
            fontSize: AppTheme.fontSizeXSmall,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor.withOpacity(0.3),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          side: BorderSide.none,
        ),
      )).toList(),
    );
  }

  /// Level indicator with title (no borders)
  static Widget levelIndicator({
    required String level,
    required String title,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            level,
            style: TextStyle(
              color: textColor ?? AppTheme.primaryColor,
              fontSize: AppTheme.fontSizeSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (title.isNotEmpty) ...[
            const SizedBox(width: AppTheme.spacingXSmall),
            Text(
              title,
              style: TextStyle(
                color: textColor ?? AppTheme.primaryColor,
                fontSize: AppTheme.fontSizeSmall,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Simple text-based loading indicator
  static Widget loadingText() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Text(
          'Loading...',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      }
    );
  }
} 