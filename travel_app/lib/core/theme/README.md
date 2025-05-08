# Glint App Styling Guidelines

This document outlines the styling guidelines for the Glint travel app to ensure consistency across all components and screens.

## Design System Structure

Our design system is organized in three layers:

1. **AppTheme**: The foundational layer containing design tokens (colors, spacing, typography scales, etc.)
2. **CommonStyles**: Reusable styles built on top of AppTheme tokens
3. **AppComponents**: Pre-built UI components with consistent styling

## How to Use

### 1. Basic Theme Values

For basic theme values (colors, spacing, typography), import the AppTheme:

```dart
import '../../core/theme/app_theme.dart';

// Examples:
Color myColor = AppTheme.primaryColor;
double padding = AppTheme.spacingMedium;
double fontSize = AppTheme.fontSizeSmall;
```

### 2. Reusable Styles

For reusable styles like text styles, card decorations, etc.:

```dart
import '../../core/widgets/common_styles.dart';

// Examples:
Text(
  'My Heading',
  style: CommonStyles.headingLarge,
);

Container(
  decoration: CommonStyles.cardDecoration,
  padding: CommonStyles.standardPadding,
  // ...
);

ElevatedButton(
  // ...
  style: CommonStyles.primaryButtonStyle,
);
```

### 3. Reusable Components

For pre-built UI components:

```dart
import '../../core/widgets/app_components.dart';

// Examples:
AppComponents.searchBar(
  controller: _searchController,
  hintText: 'Search destinations...',
);

AppComponents.sectionTitle(
  title: 'Popular Destinations',
  onViewAll: () { /* ... */ },
);

AppComponents.cachedImage(
  imageUrl: 'https://example.com/image.jpg',
  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
);
```

## Style Constants

### Colors

- `AppTheme.primaryColor`: Primary accent color
- `AppTheme.secondaryColor`: Secondary accent color
- `AppTheme.backgroundColor`: App background
- `AppTheme.surfaceColor`: Card and component backgrounds
- `AppTheme.textPrimaryColor`: Main text color
- `AppTheme.textSecondaryColor`: Secondary text color
- `AppTheme.textTertiaryColor`: Hint/disabled text color

### Typography

- `AppTheme.fontSizeXSmall`: 10.0
- `AppTheme.fontSizeSmall`: 12.0
- `AppTheme.fontSizeMedium`: 14.0
- `AppTheme.fontSizeLarge`: 16.0
- `AppTheme.fontSizeXLarge`: 18.0
- `AppTheme.fontSizeXXLarge`: 20.0
- `AppTheme.fontSizeDisplay`: 24.0

### Spacing

- `AppTheme.spacingXSmall`: 4.0
- `AppTheme.spacingSmall`: 8.0
- `AppTheme.spacingMedium`: 12.0
- `AppTheme.spacingLarge`: 16.0
- `AppTheme.spacingXLarge`: 24.0

### Border Radius

- `AppTheme.borderRadiusSmall`: 8.0
- `AppTheme.borderRadiusMedium`: 12.0
- `AppTheme.borderRadiusLarge`: 16.0

### Component Heights

- `AppTheme.buttonHeightSmall`: 32.0
- `AppTheme.buttonHeightMedium`: 40.0
- `AppTheme.buttonHeightLarge`: 48.0
- `AppTheme.inputHeight`: 42.0
- `AppTheme.chipHeight`: 28.0

### Icon Sizes

- `AppTheme.iconSizeSmall`: 16.0
- `AppTheme.iconSizeMedium`: 20.0
- `AppTheme.iconSizeLarge`: 24.0

## Best Practices

1. **Always use the theme system** rather than hardcoding values
2. **Use the AppComponents** for common UI patterns when possible
3. **Extend CommonStyles** when creating new styled components
4. **Avoid duplicating styles** across components
5. **Update the design system** when adding new patterns that should be reused

When making changes to the design system:
- Update `app_theme.dart` for token changes
- Update `common_styles.dart` for style changes
- Update `app_components.dart` for component changes

## Examples

See the following files for examples of how to use the design system:
- `lib/features/explore/explore_page.dart`
- `lib/features/itinerary/itinerary_details_page.dart` 