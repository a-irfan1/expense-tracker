// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseMainHash() => r'6da7867b8d77eb35ad95df766e0492219aa6c2b5';

/// See also [ExpenseMain].
@ProviderFor(ExpenseMain)
final expenseMainProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseMain, double>.internal(
  ExpenseMain.new,
  name: r'expenseMainProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$expenseMainHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseMain = AutoDisposeAsyncNotifier<double>;
String _$expenseByCountHash() => r'8afa7511101041348a6080a72a304ed95c370fb3';

/// See also [ExpenseByCount].
@ProviderFor(ExpenseByCount)
final expenseByCountProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseByCount, int>.internal(
  ExpenseByCount.new,
  name: r'expenseByCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseByCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseByCount = AutoDisposeAsyncNotifier<int>;
String _$expenseCategoryHash() => r'9c9ba2dc5e30c859de93a7e7b515116b2a99abdb';

/// See also [ExpenseCategory].
@ProviderFor(ExpenseCategory)
final expenseCategoryProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseCategory, List<double>>.internal(
  ExpenseCategory.new,
  name: r'expenseCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseCategory = AutoDisposeAsyncNotifier<List<double>>;
String _$expenseFilterHash() => r'fb4b205b1d2cc46456e1f3791480a6fa4f92d97f';

/// See also [ExpenseFilter].
@ProviderFor(ExpenseFilter)
final expenseFilterProvider =
    AutoDisposeNotifierProvider<ExpenseFilter, List<Expense>>.internal(
  ExpenseFilter.new,
  name: r'expenseFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseFilter = AutoDisposeNotifier<List<Expense>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
