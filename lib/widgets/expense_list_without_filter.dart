import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/util/config.dart';
import 'package:expense_tracker/widgets/expense_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../collections/expense.dart';

class ExpenseListWithoutFilter extends StatelessWidget {
  const ExpenseListWithoutFilter(
      {super.key, required this.snapshot, required this.ref});

  final AsyncSnapshot<List<Expense?>> snapshot;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: const Color.fromARGB(255, 0, 182, 218),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          onDismissed: (direction) {
            ref
                .watch(expenseFilterProvider.notifier)
                .deleteExpense(snapshot.data![index]!);
          },
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ExpenseDetail.routeName,
                  arguments:
                      ExpenseDetailArguments(expense: snapshot.data![index]!));
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  "${categories[snapshot.data![index]!.category!.index]["icon"]}",
                  width: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListTile(
                    title: Text(
                      categories[snapshot.data![index]!.category!.index]
                          ["name"],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    trailing: Text(
                      "\$${snapshot.data![index]!.amount}",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 182, 218),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Color.fromARGB(255, 0, 182, 218),
          thickness: 0.5,
          indent: 50,
        );
      },
      itemCount: snapshot.data!.length,
    );
  }
}
