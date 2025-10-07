import 'package:flutter/material.dart';

// Future<bool?> showDeleteDialog(
//   BuildContext context,) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: title != null ? Text(title) : null,
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(confirmLabel),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(cancelLabel),
//           ),
//         ],
//       );
//     },
//   );
// }

Future<bool?> showDeleteDialog(
  BuildContext context, {
  String? title,
  String content = 'ایا برای حذف ایتم مطمئن هستید؟',
  String confirmLabel = 'بله',
  String cancelLabel = 'خیر',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // آیکون هشدار
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 40,
            ),
          ),
          SizedBox(height: 20),

          // عنوان
          Text(
            title ?? 'حذف ایتم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),

          // متن پیام
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),

          // دکمه‌ها
          Row(
            children: [
              // دکمه انصراف
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(cancelLabel),
                ),
              ),
              SizedBox(width: 12),

              // دکمه حذف
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(confirmLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
