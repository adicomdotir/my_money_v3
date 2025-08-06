# Shared Widgets

This directory contains reusable widgets that are used across multiple features in the application.

## Widgets

### ErrorWidget
A generic error display widget that shows an error message with a retry button.

**Usage:**
```dart
import 'package:my_money_v3/shared/widgets/error_widget.dart' as error_widget;

// In your widget
error_widget.ErrorWidget(
  onPress: () => _retryAction(),
)
```

## Guidelines

1. **Cross-feature usage**: Only add widgets here if they are used in multiple features
2. **Generic and reusable**: Widgets should be generic enough to be reused
3. **Consistent naming**: Use descriptive names and follow the existing naming conventions
4. **Documentation**: Add usage examples in comments for complex widgets

## Import Pattern

To avoid naming conflicts with Flutter's built-in widgets, use the `as` alias pattern:

```dart
import 'package:my_money_v3/shared/widgets/error_widget.dart' as error_widget;
```

This pattern is already established in the codebase and should be followed for all shared widgets. 