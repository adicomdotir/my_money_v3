# Migration Guide for Utils Refactoring

This guide helps you update existing imports to use the new refactored utils structure.

## Import Changes

### Old Imports → New Imports

| Old Import | New Import |
|------------|------------|
| `import 'package:your_app/core/utils/constants.dart';` | `import 'package:your_app/core/utils/constants/app_constants.dart';` |
| `import 'package:your_app/core/utils/hex_color.dart';` | `import 'package:your_app/core/utils/colors/hex_color.dart';` |
| `import 'package:your_app/core/utils/price_format.dart';` | `import 'package:your_app/core/utils/formatting/price_formatter.dart';` |
| `import 'package:your_app/core/utils/date_format.dart';` | `import 'package:your_app/core/utils/formatting/date_formatter.dart';` |
| `import 'package:your_app/core/utils/app_colors.dart';` | `import 'package:your_app/core/utils/colors/app_colors.dart';` |
| `import 'package:your_app/core/utils/app_strings.dart';` | `import 'package:your_app/core/utils/constants/app_constants.dart';` |
| `import 'package:your_app/core/utils/assets_manager.dart';` | `import 'package:your_app/core/utils/assets/assets_manager.dart';` |
| `import 'package:your_app/core/utils/id_generator.dart';` | `import 'package:your_app/core/utils/generators/id_generator.dart';` |
| `import 'package:your_app/core/utils/media_query_values.dart';` | `import 'package:your_app/core/utils/ui/ui_utils.dart';` |
| `import 'package:your_app/core/utils/numeric_text_formatter.dart';` | `import 'package:your_app/core/utils/formatting/numeric_formatter.dart';` |
| `import 'package:your_app/core/utils/opposite_color.dart';` | `import 'package:your_app/core/utils/colors/app_colors.dart';` |
| `import 'package:your_app/core/utils/functions/functions.dart';` | `import 'package:your_app/core/utils/formatting/date_formatter.dart';` |

## Function Name Changes

### Price Formatting
```dart
// Old
String price = priceFormat(1000, 0);
String unit = priceSignString(0);

// New
String price = formatPrice(1000, 0);
String unit = getCurrencyUnit(0);
```

### Date Formatting
```dart
// Old
String date = dateFormat(milliseconds);
String month = getMonthName(monthIndex);

// New
String date = formatDate(milliseconds);
String month = getPersianMonthName(monthIndex);
```

### ID Generation
```dart
// Old
String id = idGenerator();

// New
String id = IDGenerator.generateTimestampId();
```

### Color Utilities
```dart
// Old
Color color = HexColor('#FF0000');
Color opposite = generateOppositeColor('#FF0000');

// New
Color color = AppColors.fromHex('#FF0000');
Color opposite = AppColors.getOppositeColor('#FF0000');
```

### Constants
```dart
// Old
String appName = 'My Money';
String toman = 'تومان';

// New
String appName = AppConstants.appName;
String toman = AppConstants.toman;
```

### UI Utilities
```dart
// Old
double height = MediaQuery.of(context).size.height;
showErrorDialog(context: context, msg: 'Error');

// New
double height = context.height;
UIUtils.showErrorDialog(context: context, message: 'Error');
```

## Bulk Import Update

To update all imports at once, you can use the barrel file:

```dart
// Replace all individual utils imports with:
import 'package:your_app/core/utils/utils.dart';
```

This will give you access to all utilities through a single import.

## Search and Replace Patterns

Use these patterns in your IDE's search and replace:

1. **Price Formatting:**
   - Find: `priceFormat(`
   - Replace: `formatPrice(`

2. **Date Formatting:**
   - Find: `dateFormat(`
   - Replace: `formatDate(`

3. **ID Generation:**
   - Find: `idGenerator()`
   - Replace: `IDGenerator.generateTimestampId()`

4. **Constants:**
   - Find: `'My Money'`
   - Replace: `AppConstants.appName`

5. **Color Utilities:**
   - Find: `HexColor(`
   - Replace: `AppColors.fromHex(`

## Testing

After migration, test the following functionality:
- Price formatting in expense screens
- Date formatting in reports
- ID generation for new records
- Color utilities in UI components
- Dialog displays
- Media query extensions

## Rollback Plan

If issues arise, you can temporarily revert by:
1. Restoring the old utils files
2. Updating imports back to old structure
3. Using the old function names

The refactored code maintains the same functionality while providing better organization and additional utilities. 