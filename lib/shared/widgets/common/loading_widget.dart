import 'package:flutter/material.dart';

/// A reusable loading widget that provides consistent loading states
/// across the application.
class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.size = 24.0,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A loading widget specifically for buttons and small areas
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const AppLoadingIndicator({
    super.key,
    this.size = 16.0,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
