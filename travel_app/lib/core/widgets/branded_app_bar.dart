import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import 'brand_logo.dart';
import 'package:flutter/rendering.dart';

/// A custom app bar that incorporates the Glint brand logo with Kumbh Sans font
class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color? backgroundColor;
  
  /// Determines if the logo and title are in a row (false) or column (true)
  final bool stackedLayout;
  
  const BrandedAppBar({
    super.key,
    this.title,
    this.showLogo = true,
    this.actions,
    this.bottom,
    this.centerTitle = false,
    this.backgroundColor,
    this.stackedLayout = false,
  });
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.colorScheme.brightness;
    final contrastColor = brightness == Brightness.light ? Colors.black87 : Colors.white;
    
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: kToolbarHeight,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.background.withOpacity(0.7),
            ),
          ),
          title: showLogo ? BrandLogo(fontSize: 24, color: contrastColor) : null,
          centerTitle: centerTitle,
          actions: actions,
          bottom: bottom,
        ),
      ),
    );
  }
} 