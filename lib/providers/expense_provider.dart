import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/util/functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_provider.g.dart';

@riverpod
class ExpenseMain extends _$ExpenseMain with Functions {
  @override
  Future<double> build() => getTotalExpenses().then((value) => value);
}

@riverpod
class ExpenseByCount extends _$ExpenseByCount with Functions {
  @override
  Future<int> build() => expensesByCount().then((value) => value);
}

@riverpod
class ExpenseCategory extends _$ExpenseCategory with Functions {
  @override
  Future<List<double>> build() => sumByCategory().then((value) => value);
}

@riverpod
class ExpenseFilter extends _$ExpenseFilter with Functions {
  @override
  List<Expense> build() => [];

  resetResults() {
    state.clear();
  }

  void filterByCategory(Categories value) async {
    state = await expensesByCategory(value);
  }

  void filterByAmountRange(double lowerAmount, double higherAmount) async {
    state = await expensesByAmountRange(lowerAmount, higherAmount);
  }

  void filterByAmountGreaterThan(double amount) async {
    state = await expensesByAmountGreaterThan(amount);
  }

  void filterByAmountLessThan(double amount) async {
    state = await expensesByAmountLessThan(amount);
  }

  void filterByAmountAndCategory(
      Categories value, double amountHighValue) async {
    state = await expensesByCategoryAndAmount(value, amountHighValue);
  }

  void filterByNotOthersCategory() async {
    state = await expensesByNotOthersCategory();
  }

  void filterByGroupFilter(String searchText, DateTime dateTime) async {
    state = await expensesByGroupFilter(searchText, dateTime);
  }

  void filterByPaymentMethod(String searchText) async {
    state = await expensesByPaymentMethod(searchText);
  }

  void filterByUsingAny(List<Categories> categories) async {
    state = await expensesByUsingAny(categories);
  }

  void filterByUsingAll(List<Categories> categories) async {
    state = await expensesByUsingAll(categories);
  }

  void filterBySubCategory(String subCategory) async {
    state = await expensesBySubCategory(subCategory);
  }

  void filterByReceipt(String receiptName) async {
    state = await expensesByReceipts(receiptName);
  }

  void filterByPagination(int offset) async {
    state = await expensesByPagination(offset);
  }

  void filterByFindingFirst() async {
    state = await expensesByFindFirst();
  }

  void filterByDeletingFirst() async {
    state = await expensesByDeleteFirst();
  }

  void deleteExpense(Expense collection) async {
    state = await deleteItem(collection);
    ref.invalidateSelf();
  }
}
