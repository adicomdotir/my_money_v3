import 'package:flutter/material.dart';

/// A reusable input decorator widget that provides consistent styling
/// for form inputs across the application.
class AppInputDecorator extends StatelessWidget {
  final String labelText;
  final Widget child;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Color? borderColor;
  final bool isError;

  const AppInputDecorator({
    required this.labelText,
    required this.child,
    super.key,
    this.borderRadius = 16.0,
    this.isError = false,
    this.borderColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: isError
                ? Theme.of(context).colorScheme.error
                : borderColor ?? Theme.of(context).colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
      child: child,
    );
  }
}
