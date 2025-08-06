import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Extension on BuildContext for easy access to MediaQuery values.
extension MediaQueryValues on BuildContext {
  /// Screen height
  double get height => MediaQuery.of(this).size.height;

  /// Screen width
  double get width => MediaQuery.of(this).size.width;

  /// Top padding (status bar height)
  double get topPadding => MediaQuery.of(this).viewPadding.top;

  /// Bottom padding (navigation bar height)
  double get bottomPadding => MediaQuery.of(this).viewPadding.bottom;

  /// Bottom inset (keyboard height)
  double get bottomInset => MediaQuery.of(this).viewInsets.bottom;

  /// Whether the device is in landscape mode
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Whether the device is in portrait mode
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Text scale factor
  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;
}

/// Utility class for common UI operations.
class UIUtils {
  const UIUtils._();

  /// Shows a simple error dialog with customizable message.
  ///
  /// [context] is the build context.
  /// [message] is the error message to display.
  /// [title] is the dialog title (optional).
  static void showErrorDialog({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title ?? 'خطا',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('تایید'),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog.
  ///
  /// [context] is the build context.
  /// [title] is the dialog title.
  /// [message] is the dialog message.
  /// [confirmText] is the confirm button text.
  /// [cancelText] is the cancel button text.
  /// [onConfirm] is the callback when confirmed.
  /// [onCancel] is the callback when cancelled.
  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'تایید',
    String cancelText = 'انصراف',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onCancel?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows a loading dialog.
  ///
  /// [context] is the build context.
  /// [message] is the loading message.
  static void showLoadingDialog({
    required BuildContext context,
    String message = 'لطفا صبر کنید...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(width: 16),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hides the current dialog.
  ///
  /// [context] is the build context.
  static void hideDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
