import 'dart:math';

/// Utility class for generating unique identifiers
class IDGenerator {
  const IDGenerator._();

  /// Generates a unique ID based on current timestamp in microseconds
  static String generateTimestampId() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  /// Generates a unique ID based on current timestamp in milliseconds
  static String generateMillisecondId() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  /// Generates a random alphanumeric ID of specified length
  static String generateRandomId([int length = 8]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Generates a UUID-like string (not a true UUID, but similar format)
  static String generateUUID() {
    final random = Random();
    final parts = <String>[];

    for (int i = 0; i < 4; i++) {
      parts.add(random.nextInt(0x10000).toRadixString(16).padLeft(4, '0'));
    }

    return '${parts[0]}-${parts[1]}-${parts[2]}-${parts[3]}';
  }

  /// Generates a numeric ID with specified length
  static String generateNumericId([int length = 6]) {
    final random = Random();
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(random.nextInt(10));
    }

    return buffer.toString();
  }

  /// Generates a unique ID combining timestamp and random string
  static String generateCombinedId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateRandomId(4);
    return '${timestamp}_$random';
  }
}
