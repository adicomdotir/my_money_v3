class AppConstants {
  const AppConstants._();

  // App Information
  static const String appName = 'My Money';
  static const String fontFamily = 'Vazir';

  // HTTP Constants
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';

  // Cache Keys
  static const String cachedHomeInfo = 'CACHED_HOME_INFO';
  static const String cachedExpense = 'CACHED_EXPENSE';

  // Error Messages
  static const String serverFailure = 'Server Failure';
  static const String cacheFailure = 'Cache Failure';
  static const String unexpectedError = 'Unexpected Error';
  static const String noRouteFound = 'No Route Found';

  // Localization
  static const String englishCode = 'en';
  static const String farsiCode = 'fa';
  static const String locale = 'locale';
  static const String settings = 'settings';

  // Persian Calendar Months
  static const List<String> persianMonths = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  // Currency Units
  static const String toman = 'تومان';
  static const String rial = 'ریال';
}
