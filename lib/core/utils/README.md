# Utils Directory

This directory contains utility functions and classes organized by category for better maintainability and discoverability.

## Structure

```
utils/
├── constants/
│   └── app_constants.dart          # Application-wide constants
├── colors/
│   ├── app_colors.dart             # Color definitions and utilities
│   └── hex_color.dart              # Hex color parsing
├── formatting/
│   ├── price_formatter.dart        # Price formatting utilities
│   ├── date_formatter.dart         # Date formatting utilities
│   └── numeric_formatter.dart      # Numeric input formatters
├── ui/
│   └── ui_utils.dart               # UI-related utilities and extensions
├── assets/
│   └── assets_manager.dart         # Asset path management
├── generators/
│   └── id_generator.dart           # ID generation utilities
└── utils.dart                      # Barrel file for easy importing
```

## Usage

### Import all utilities
```dart
import 'package:your_app/core/utils/utils.dart';
```

### Import specific categories
```dart
import 'package:your_app/core/utils/constants/app_constants.dart';
import 'package:your_app/core/utils/colors/app_colors.dart';
import 'package:your_app/core/utils/formatting/price_formatter.dart';
```

## Categories

### Constants (`constants/`)
- Application-wide constants
- Error messages
- Localization codes
- Persian calendar months
- Currency units

### Colors (`colors/`)
- App color definitions
- Hex color parsing
- Opposite color generation
- Color utilities

### Formatting (`formatting/`)
- Price formatting with currency units
- Date formatting (Persian calendar)
- Numeric input formatters
- Number formatting utilities

### UI Utilities (`ui/`)
- MediaQuery extensions
- Dialog utilities
- UI helper functions

### Assets (`assets/`)
- Asset path constants
- Asset management utilities
- Font path management

### Generators (`generators/`)
- ID generation utilities
- Timestamp-based IDs
- Random ID generation
- UUID-like strings

## Migration Guide

### Old Usage → New Usage

**Price Formatting:**
```dart
// Old
String price = priceFormat(1000, 0);

// New
String price = formatPrice(1000, 0);
```

**Date Formatting:**
```dart
// Old
String date = dateFormat(milliseconds);

// New
String date = formatDate(milliseconds);
```

**ID Generation:**
```dart
// Old
String id = idGenerator();

// New
String id = IDGenerator.generateTimestampId();
```

**Color Utilities:**
```dart
// Old
Color color = HexColor('#FF0000');
Color opposite = generateOppositeColor('#FF0000');

// New
Color color = AppColors.fromHex('#FF0000');
Color opposite = AppColors.getOppositeColor('#FF0000');
```

**Constants:**
```dart
// Old
String appName = 'My Money';

// New
String appName = AppConstants.appName;
```

## Benefits of Refactoring

1. **Better Organization**: Related utilities are grouped together
2. **Improved Discoverability**: Clear category structure makes it easy to find utilities
3. **Single Responsibility**: Each file has a clear, focused purpose
4. **Better Documentation**: Comprehensive documentation for all utilities
5. **Easier Maintenance**: Changes to specific functionality are isolated
6. **Consistent Naming**: Standardized naming conventions across all utilities
7. **Enhanced Functionality**: Added more utility functions and improved existing ones 