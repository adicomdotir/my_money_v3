import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog(
  BuildContext context, {
  String? title,
  String content = 'ایا برای حذف ایتم مطمئن هستید؟',
  String confirmLabel = 'بله',
  String cancelLabel = 'خیر',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
        ],
      );
    },
  );
}
