class IconCatalog {
  IconCatalog._();

  static const String defaultIconKey = 'ic_other';

  // Keep this list in sync with assets/expense_categories/expense_categories/*.png
  static const List<String> allIconKeys = [
    'ic_accessory',
    'ic_award',
    'ic_beer',
    'ic_boat',
    'ic_book',
    'ic_car',
    'ic_Clothes',
    'ic_coffe',
    'ic_computer',
    'ic_cosmetic',
    'ic_drink',
    'ic_electric',
    'ic_entertainmmment',
    'ic_fitness',
    'ic_Food',
    'ic_fruit',
    'ic_gift',
    'ic_grocery',
    'ic_home',
    'ic_hotel',
    'ic_icecream',
    'ic_launcher',
    'ic_laundry',
    'ic_medical',
    'ic_noodle',
    'ic_oil',
    'ic_other',
    'ic_people',
    'ic_phone',
    'ic_pill',
    'ic_pizza',
    'ic_plane',
    'ic_restaurant',
    'ic_saving',
    'ic_sell',
    'ic_shopping',
    'ic_sweet',
    'ic_taxi',
    'ic_train',
    'ic_water',
    'ic_working',
  ];

  static String assetFor(String iconKey) {
    return 'assets/expense_categories/expense_categories/' '$iconKey.png';
  }
}
