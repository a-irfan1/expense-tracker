import 'package:expense_tracker/collections/receipt.dart';
import '../collections/expense.dart';
import 'adapter.dart';
import 'package:isar/isar.dart';

import '../main.dart';

class ExpenseRepository extends Adapter<Expense> {
  @override
  Future<void> createMultipleObjects(List<Expense> collections) async {
    await isar.writeTxn(() async {
      await isar.expenses.putAll(collections);
    });
  }

  @override
  Future<void> createObject(Expense collection) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(collection);

      await collection.receipts.save();
    });
  }

  @override
  Future<List<Expense>> deleteObject(Expense collection) async {
    await isar.writeTxn(() async {
      await isar.expenses.delete(collection.id);
    });

    return await isar.expenses.where().findAll();
  }

  @override
  Future<void> deleteMultipleObjects(List<int> ids) async {
    await isar.expenses.deleteAll(ids);
  }

  @override
  Future<List<Expense>> getAllObjects() async {
    return await isar.expenses.where().findAll();
  }

  @override
  Future<Expense?> getObjectByID(int id) async {
    return await isar.expenses.get(id);
  }

  @override
  Future<List<Expense?>> getMultipleObjectsByIDs(List<int> ids) async {
    return await isar.expenses.getAll(ids);
  }

  @override
  Future<void> updateObject(Expense collection) async {
    await isar.writeTxn(() async {
      final budget = await isar.expenses.get(collection.id);

      if (budget != null) {
        await isar.expenses.put(collection);
      }
    });
  }

  Future<List<Expense>> getObjectsByToday() async {
    return await isar.expenses
        .where()
        .dateEqualTo(DateTime.now().copyWith(
            hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0))
        .findAll();
  }

  Future<double> getSumForCategory(Categories value) async {
    return await isar.expenses
        .filter()
        .categoryEqualTo(value)
        .amountProperty()
        .sum();
  }

  Future<List<Expense>> getObjectsByCategory(Categories value) async {
    return await isar.expenses.filter().categoryEqualTo(value).findAll();
  }

  Future<List<Expense>> getObjectsByAmountRange(
      double lowAmount, double highAmount) async {
    return await isar.expenses
        .filter()
        .amountBetween(lowAmount, highAmount, includeLower: false)
        .findAll();
  }

  Future<List<Expense>> getObjectsWithAmountGreaterThan(
      double amountValue) async {
    return await isar.expenses
        .filter()
        .amountGreaterThan(amountValue)
        .findAll();
  }

  Future<List<Expense>> getObjectsWithAmountLessThan(double amountValue) async {
    return await isar.expenses.filter().amountLessThan(amountValue).findAll();
  }

  Future<List<Expense>> getObjectsByOptions(
      Categories value, double amountHighValue) async {
    return await isar.expenses
        .filter()
        .categoryEqualTo(value)
        .or()
        .amountGreaterThan(amountHighValue)
        .findAll();
  }

  Future<List<Expense>> getObjectsNotOthersCategory() async {
    return await isar.expenses
        .filter()
        .not()
        .categoryEqualTo(Categories.others)
        .findAll();
  }

  Future<List<Expense>> getObjectsByGroupFilter(
      String searchText, DateTime dateTime) async {
    return await isar.expenses
        .filter()
        .categoryEqualTo(Categories.others)
        .group((q) =>
            q.paymentMethodContains(searchText).or().dateEqualTo(dateTime))
        .findAll();
  }

  Future<List<Expense>> getObjectsBySearchText(String searchText) async {
    return await isar.expenses
        .filter()
        .paymentMethodStartsWith(searchText, caseSensitive: false)
        .or()
        .paymentMethodEndsWith(searchText, caseSensitive: false)
        .findAll();
  }

  Future<List<Expense>> getObjectsUsingAnyOf(
      List<Categories> categories) async {
    return await isar.expenses
        .filter()
        .anyOf(categories, (q, Categories cat) => q.categoryEqualTo(cat))
        .findAll();
  }

  Future<List<Expense>> getObjectsUsingAllOf(
      List<Categories> categories) async {
    return await isar.expenses
        .filter()
        .allOf(categories, (q, Categories cat) => q.categoryEqualTo(cat))
        .findAll();
  }

  Future<List<Expense>> getObjectsWithoutPaymentMethod() async {
    return await isar.expenses.filter().paymentMethodIsEmpty().findAll();
  }

  Future<List<Expense>> getObjectsBySubCategory(String subCategory) async {
    return await isar.expenses
        .filter()
        .subCategory((q) => q.nameEqualTo(subCategory))
        .findAll();
  }

  Future<List<Expense>> getObjectsByReceipts(String receiptName) async {
    return await isar.expenses.filter().receipts((q) {
      return q.nameEqualTo(receiptName).or().nameContains(receiptName);
    }).findAll();
  }

  Future<List<Expense>> getObjectsAndPaginate(int offset) async {
    return await isar.expenses.where().offset(offset).limit(3).findAll();
  }

  Future<List<Expense>> getObjectsWithDistinctValues() async {
    return await isar.expenses.where().distinctByCategory().findAll();
  }

  Future<List<Expense>> getOnlyFirstObject() async {
    List<Expense> querySelected = [];

    await isar.expenses.where().findFirst().then((value) {
      if (value != null) {
        querySelected.add(value);
      }
    });

    return querySelected;
  }

  Future<List<Expense>> deleteOnlyFirstObject() async {
    await isar.writeTxn(() async {
      await isar.expenses.where().deleteFirst();
    });

    return await isar.expenses.where().findAll();
  }

  Future<int> getTotalObjects() async {
    return await isar.expenses.where().count();
  }

  Future<void> clearData() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }

  Future<List<String?>> getPaymentProperty() async {
    return await isar.expenses.where().paymentMethodProperty().findAll();
  }

  Future<double> totalExpenses() async {
    return await isar.expenses.where().amountProperty().sum();
  }

  Future<double> totalExpensesByCategory() async {
    return await isar.expenses
        .where()
        .distinctByCategory()
        .amountProperty()
        .sum();
  }
}
