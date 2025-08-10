# Shared Widgets

This directory contains reusable widgets that are used across multiple features in the application.

## Structure

```
lib/shared/widgets/
├── common/              # Common UI widgets
│   ├── dropdown_widget.dart      # Generic dropdown widget
│   ├── input_decorator.dart      # Reusable input decoration
│   └── loading_widget.dart       # Loading indicators
├── error_widget.dart    # Error display widget
├── widgets.dart         # Widgets barrel export
└── README.md           # This file
```

## Widgets

### Common Widgets

#### AppDropdownWidget
A generic dropdown widget that can be used for any type of data with customizable item builders and styling. Supports optional empty values.

**Usage:**
```dart
import 'package:my_money_v3/shared/widgets/widgets.dart';

// Basic usage
AppDropdownWidget<String>(
  value: selectedValue,
  items: ['Option 1', 'Option 2', 'Option 3'],
  labelText: 'Select Option',
  hintText: 'Choose an option',
  onChanged: (value) => _handleSelection(value),
)

// With empty value support
AppDropdownWidget<String>(
  value: selectedValue,
  items: ['Option 1', 'Option 2', 'Option 3'],
  labelText: 'Select Option',
  hintText: 'Choose an option',
  allowEmpty: true,
  emptyText: 'Please select',
  emptyValue: '',
  onChanged: (value) => _handleSelection(value),
)
```

**Parameters:**
- `value`: Currently selected value (can be null)
- `items`: List of available options
- `allowEmpty`: Whether to show an empty option (default: false)
- `emptyText`: Text to display for the empty option
- `emptyValue`: Value to use for the empty option
- `onChanged`: Callback when selection changes (receives nullable value)

#### AppInputDecorator
A reusable input decorator widget that provides consistent styling for form inputs across the application.

**Usage:**
```dart
import 'package:my_money_v3/shared/widgets/widgets.dart';

AppInputDecorator(
  labelText: 'Input Label',
  child: TextFormField(
    decoration: const InputDecoration(),
  ),
)
```

#### AppLoadingWidget
A reusable loading widget that provides consistent loading states across the application.

**Usage:**
```dart
import 'package:my_money_v3/shared/widgets/widgets.dart';

const AppLoadingWidget(
  message: 'Loading...',
  size: 24.0,
)
```

#### AppLoadingIndicator
A loading widget specifically for buttons and small areas.

**Usage:**
```dart
import 'package:my_money_v3/shared/widgets/widgets.dart';

const AppLoadingIndicator(size: 16.0)
```

### Error Widget
A generic error display widget that shows an error message with a retry button.

**Usage:**
```dart
import 'package:my_money_v3/shared/widgets/widgets.dart';

ErrorWidget(
  onPress: () => _retryAction(),
)
```

## Guidelines

1. **Cross-feature usage**: Only add widgets here if they are used in multiple features
2. **Generic and reusable**: Widgets should be generic enough to be reused
3. **Consistent naming**: Use descriptive names and follow the existing naming conventions
4. **Documentation**: Add usage examples in comments for complex widgets
5. **Theme integration**: Use Theme.of(context) for colors and text styles
6. **Responsive design**: Make widgets responsive and accessible

## Import Pattern

Use the barrel export for clean imports:

```dart
import 'package:my_money_v3/shared/widgets/widgets.dart';
```

Or import specific widgets:

```dart
import 'package:my_money_v3/shared/widgets/common/dropdown_widget.dart';
``` 