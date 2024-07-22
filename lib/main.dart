import 'package:expense_tracker/collections/budget.dart';
import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/collections/income.dart';
import 'package:expense_tracker/collections/receipt.dart';
import 'package:expense_tracker/home.dart';
import 'package:expense_tracker/widgets/expense_details.dart';
import 'package:expense_tracker/widgets/expense_filter.dart';
import 'package:expense_tracker/widgets/expense_filter_by.dart';
import 'package:expense_tracker/widgets/expense_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    isar = await Isar.open(
        [BudgetSchema, ExpenseSchema, ReceiptSchema, IncomeSchema],
        directory: appDir.path, name: 'expenseInstance');
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      initialRoute: "/",
      routes: {
        "/": (context) => const Home(),
        ExpenseDetail.routeName: (context) => const ExpenseDetail(),
        "/filterby": (context) => const FilterBy(),
        Filter.routeName: (context) => const Filter(),
        "/search": (context) => const Search(),
      },
    );
  }
}
