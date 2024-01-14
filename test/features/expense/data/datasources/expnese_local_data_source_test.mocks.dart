// Mocks generated by Mockito 5.4.4 from annotations
// in my_money_v3/test/features/expense/data/datasources/expnese_local_data_source_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:my_money_v3/core/db/db.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [DatabaseHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseHelper extends _i1.Mock implements _i2.DatabaseHelper {
  @override
  _i3.Future<String> addCategory(
    Map<String, dynamic>? categoryJson,
    String? id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addCategory,
          [
            categoryJson,
            id,
          ],
        ),
        returnValue: _i3.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #addCategory,
            [
              categoryJson,
              id,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i3.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #addCategory,
            [
              categoryJson,
              id,
            ],
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<List<dynamic>> getCategories() => (super.noSuchMethod(
        Invocation.method(
          #getCategories,
          [],
        ),
        returnValue: _i3.Future<List<dynamic>>.value(<dynamic>[]),
        returnValueForMissingStub: _i3.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i3.Future<List<dynamic>>);

  @override
  _i3.Future<void> addExpanse(
    Map<String, dynamic>? expenseJson,
    String? id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addExpanse,
          [
            expenseJson,
            id,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteExpanse(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteExpanse,
          [id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<bool> deleteCategory(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteCategory,
          [id],
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<List<dynamic>> getExpenses([
    int? fromDate,
    int? toDate,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #getExpenses,
          [
            fromDate,
            toDate,
          ],
        ),
        returnValue: _i3.Future<List<dynamic>>.value(<dynamic>[]),
        returnValueForMissingStub: _i3.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i3.Future<List<dynamic>>);

  @override
  _i3.Future<dynamic> getHomeInfo() => (super.noSuchMethod(
        Invocation.method(
          #getHomeInfo,
          [],
        ),
        returnValue: _i3.Future<dynamic>.value(),
        returnValueForMissingStub: _i3.Future<dynamic>.value(),
      ) as _i3.Future<dynamic>);

  @override
  _i3.Future<List<Map<String, dynamic>>> getReport() => (super.noSuchMethod(
        Invocation.method(
          #getReport,
          [],
        ),
        returnValue: _i3.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
        returnValueForMissingStub: _i3.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i3.Future<List<Map<String, dynamic>>>);
}
