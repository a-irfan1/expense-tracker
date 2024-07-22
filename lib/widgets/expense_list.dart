import 'package:expense_tracker/util/functions.dart';
import 'package:expense_tracker/widgets/expense_empty_widget.dart';
import 'package:expense_tracker/widgets/expense_list_with_filter.dart';
import 'package:expense_tracker/widgets/expense_list_without_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseListWidget extends ConsumerStatefulWidget {
  const ExpenseListWidget(
      {required this.filter, required this.showAll, super.key});

  final bool filter;
  final bool showAll;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends ConsumerState<ExpenseListWidget>
    with Functions {
  @override
  Widget build(BuildContext context) {
    return (widget.filter)
        ? ExpenseListWithFilter(
            ref: ref,
            expenseListWidget: widget,
          )
        : FutureBuilder(
            future: (widget.showAll) ? getAllExpenses() : getTodaysExpenses(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return ExpenseListWithoutFilter(
                  ref: ref,
                  snapshot: snapshot,
                );
              } else {
                return const ExpenseEmptyWidget(
                    subtitle: "No data available yet!!!");
              }
            });
  }
}
