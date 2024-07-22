import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../collections/income.dart';
import 'package:expense_tracker/util/functions.dart';

part 'income_provider.g.dart';

@riverpod
class ExpenseIncome extends _$ExpenseIncome with Functions {
  @override
  Future<List<Income>> build() => getAllIncomes().then(((value) => value));
}
