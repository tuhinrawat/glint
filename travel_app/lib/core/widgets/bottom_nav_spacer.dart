import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A widget that provides consistent bottom spacing to ensure content 
/// isn't hidden behind the navigation bar when scrolling
class BottomNavSpacer extends StatelessWidget {
  // Standard height including extra padding to ensure proper scrolling
  static const double defaultHeight = 80.0;

  final double height;

  const BottomNavSpacer({
    super.key,
    this.height = defaultHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }

  /// Creates a sliver version of the spacer for use in CustomScrollView
  static Widget sliver({double height = defaultHeight}) {
    return SliverToBoxAdapter(child: SizedBox(height: height));
  }

  /// Calculates precise height based on device metrics
  static double calculateHeight(BuildContext context) {
    // Get the bottom padding (for notches, home indicators, etc.)
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    // Standard navbar height (from our AppTheme) plus padding
    const navBarHeight = 60.0;
    
    // Add extra padding to ensure smooth scrolling
    const extraPadding = 20.0;
    
    return navBarHeight + bottomPadding + extraPadding;
  }

  /// Creates a dynamically sized spacer based on the device
  static Widget dynamic(BuildContext context) {
    return SizedBox(height: calculateHeight(context));
  }

  /// Creates a sliver version with dynamic height
  static Widget sliverDynamic(BuildContext context) {
    return SliverToBoxAdapter(child: dynamic(context));
  }
} 