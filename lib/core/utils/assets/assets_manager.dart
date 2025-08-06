/// Asset paths constants
class AssetPaths {
  const AssetPaths._();

  // Base paths
  static const String imagesPath = 'assets/images';
  static const String iconsPath = 'assets/icons';
  static const String fontsPath = 'assets/fonts';

  // Image assets
  static const String logo = '$imagesPath/logo.png';

  // Font assets
  static const String iranSansBlack = '$fontsPath/IRANSans_Black.ttf';
  static const String iranSansBold = '$fontsPath/IRANSans_Bold.ttf';
  static const String iranSansLight = '$fontsPath/IRANSans_Light.ttf';
  static const String iranSansMedium = '$fontsPath/IRANSans_Medium.ttf';
  static const String iranSansRegular = '$fontsPath/IRANSans_Regular.ttf';
  static const String iranSansThin = '$fontsPath/IRANSans_Thin.ttf';
}

/// Asset management utilities
class AssetsManager {
  const AssetsManager._();

  /// Gets the full path for an image asset
  static String getImagePath(String imageName) {
    return '${AssetPaths.imagesPath}/$imageName';
  }

  /// Gets the full path for an icon asset
  static String getIconPath(String iconName) {
    return '${AssetPaths.iconsPath}/$iconName';
  }

  /// Gets the full path for a font asset
  static String getFontPath(String fontName) {
    return '${AssetPaths.fontsPath}/$fontName';
  }

  /// Gets all available font paths
  static List<String> getFontPaths() {
    return [
      AssetPaths.iranSansBlack,
      AssetPaths.iranSansBold,
      AssetPaths.iranSansLight,
      AssetPaths.iranSansMedium,
      AssetPaths.iranSansRegular,
      AssetPaths.iranSansThin,
    ];
  }
}
