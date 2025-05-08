import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'brand_logo.dart';

/// A custom app bar that incorporates the Glint brand logo with Kumbh Sans font
class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color? backgroundColor;
  
  const BrandedAppBar({
    super.key,
    this.title,
    this.showLogo = true,
    this.actions,
    this.bottom,
    this.centerTitle = false,
    this.backgroundColor,
  });
  
  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)
  );
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppTheme.backgroundColor,
      elevation: 0,
      title: showLogo 
          ? title != null
              ? Row(
                  children: [
                    const BrandLogo(fontSize: 22),
                    const SizedBox(width: 8),
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : const BrandLogo(fontSize: 24)
          : title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
      centerTitle: centerTitle,
      actions: actions,
      bottom: bottom,
    );
  }
} 