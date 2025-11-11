# My Money V3

- Begin with a version using Java in Android Native.  
  https://github.com/adicomdotir/My-Money/tree/version1
- Create a second version using Kotlin with MVP Pattern in Android Native.  
  https://github.com/adicomdotir/My-Money
- Version 2 was a simple Flutter version.  
  https://github.com/adicomdotir/my-mobile-training/tree/master/lib/my_money_app
- Now create Version 3 with Flutter and Clean Architecture.

<table>
  <tr>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/1.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/2.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/3.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/4.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/9.png"  width="100%" height="100%"></td>
  </tr>
  <tr>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/5.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/6.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/7.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/8.png"  width="100%" height="100%"></td>
    <td><img src="https://raw.github.com/adicomdotir/my_money_v3/main/screenshots/4.png"  width="100%" height="100%"></td>
  </tr>
</table>

## Overview

My Money V3 is a personal finance tracker built with Flutter and Clean Architecture. It supports category-based expense tracking, reports, localization (FA/EN), and platform persistence using Hive, with modular features and test coverage.

## Tech & Architecture

- Flutter, Dart
- State management: Bloc/Cubit
- DI: GetIt
- Storage: Hive
- Clean Architecture
  - `features/<feature>/{data,domain,presentation}`
  - Shared utilities under `lib/shared` and `lib/core`

## Getting Started

- Flutter 3.x (check `environment` in `pubspec.yaml`)
- Install dependencies:
  - `flutter pub get`
- Run:
  - `flutter run`
- Tests:
  - `flutter test`

## Features

- Expense management: add, edit, delete, list by date
- Categories: create hierarchical categories
- Reports: monthly breakdown, category distribution, percentages
- Settings: currency unit, theme, language
- Localization: FA and EN

## Category Icons

- Each category has an `iconKey` stored alongside `id`, `parentId`, `title`, `color`.
- Icons are selected from bundled assets under `assets/expense_categories/expense_categories/`.
- Add/Edit Category includes an icon picker with search and preview.
- Category dropdown renders icons next to names.
- Backward compatibility: existing data without `iconKey` defaults to `ic_other`; migration backfills it.

Developer notes:
- Add new icons by placing PNGs in the folder and adding their keys to `IconCatalog.allIconKeys`.
- Default icon key: `ic_other`.

## Monthly Dollar Rates

- Manage monthly USD rates (Jalali year/month) via Settings → Monthly Dollar Rate.
- Actions: add, edit, delete.
- Data stored in Hive (`dollar_rates_v1`).
- Clean architecture: DataSource → Repository → UseCases → Cubit → Screen.
- Rates are in Toman; conversion formula: `usd = toman / rate`.

Structure:
- Feature root: `lib/features/dollar_rate/`
  - Data: `data/datasources/`, `data/models/`, `data/repositories/`
  - Domain: `domain/entities/`, `domain/repositories/`, `domain/usecases/`
  - Presentation: `presentation/cubit/`, `presentation/screens/`
- DI wiring: `lib/injection_container.dart`
- Route: `Routes.dollarRatesRoute`

## Reports: USD Calculation

- Reports now include USD values per month and per category item, based on monthly rates.
- If no rate exists for a month, USD values default to 0; Toman totals remain.

Data flow:
- Aggregation logic: `DatabaseHelper.getReport()`:
  - Month fields: `sumPrice` (toman), `sumPriceUsd` (usd)
  - Category fields: `price` (toman), `usdPrice` (usd), `percent`
- Models/entities updated:
  - `ReportModel`: added `sumPriceUsd`; `CatExpenseModel`: added `usdPrice`
  - `ReportEntity`: added `sumPriceUsd`; `CatExpense`: added `usdPrice`
- UI can display both Toman and USD in report widgets.

## Testing

- Unit tests for core utils, DB, and models (see `test/`)
- Widget tests for UI flows (e.g., icon picker, dropdown)
- Integration tests for cross-feature flows (e.g., category with icon used in expenses)

Run:
- `flutter test`

## Contributing

- Follow feature-based structure (`lib/features/<feature>/...`)
- Use DI for new services and wire them in `injection_container.dart`
- Add tests for new logic (unit/widget as appropriate)
- Keep README updated for new user-facing features