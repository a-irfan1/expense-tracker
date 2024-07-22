import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/util/config.dart';
import 'package:expense_tracker/widgets/expense_details.dart';
import 'package:expense_tracker/widgets/expense_divider.dart';
import 'package:expense_tracker/widgets/expense_empty_widget.dart';
import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseListWithFilter extends StatelessWidget {
  const ExpenseListWithFilter(
      {super.key, required this.ref, required this.expenseListWidget});

  final WidgetRef ref;
  final ExpenseListWidget expenseListWidget;

  @override
  Widget build(BuildContext context) {
    return (ref.watch(expenseFilterProvider).isEmpty)
        ? const ExpenseEmptyWidget(subtitle: "No data available yet!")
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ExpenseDetail.routeName,
                      arguments: ExpenseDetailArguments(
                          expense: ref.watch(expenseFilterProvider)[index]));
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/${categories[ref.watch(expenseFilterProvider)[index].category!.index]["icon"]}",
                      width: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      child: ListTile(
                        title: Text(
                          categories[ref
                              .watch(expenseFilterProvider)[index]
                              .category!
                              .index]["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Text(
                          "\$ ${ref.watch(expenseFilterProvider)[index].amount}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 182, 218),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const ExpenseDivider();
            },
            itemCount: ref.watch(expenseFilterProvider).length);
  }
}
