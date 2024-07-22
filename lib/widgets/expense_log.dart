import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/functions.dart';

class ExpenseLog extends ConsumerStatefulWidget {
  const ExpenseLog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpenseLogState();
}

class _ExpenseLogState extends ConsumerState<ExpenseLog> with Functions {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/filterBy");
            },
            icon: const Icon(
              Icons.tune,
              color: Color.fromARGB(255, 0, 182, 218),
            ),
          ),
        ),
        FutureBuilder(
          future: expensesByCount(),
          builder: (context, snapshot) {
            return Text(
              "${snapshot.data} items",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 182, 218),
              ),
            );
          },
        ),
        const ExpenseListWidget(filter: false, showAll: true),
      ],
    );
  }
}
