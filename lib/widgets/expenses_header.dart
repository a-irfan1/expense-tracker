import 'package:expense_tracker/collections/budget.dart';
import 'package:expense_tracker/providers/budget_provider.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  const HeaderWidget({super.key, required this.editBudget});

  final bool editBudget;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  double percent = 0.0;
  double budgetSpent = 0.0;
  double monthlyBudget = 0.0;

  final TextEditingController budgetTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Budget?> limit = ref.watch(expenseBudgetProvider);
    final AsyncValue<double?> spent = ref.watch(expenseMainProvider);

    budgetSpent = switch (spent) {
      AsyncData(:final value) => value!,
      AsyncError() => 0,
      _ => 0,
    };

    monthlyBudget = switch (limit) {
      AsyncData(:final value) => value?.amount ?? 0,
      AsyncError() => 0,
      _ => 0,
    };

    Future.delayed(Duration.zero, () {
      budgetTextController.text = monthlyBudget.toString();
    });

    percent = (budgetSpent / monthlyBudget);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 0, 182, 218),
              ),
              DateFormat.MMMM().format(
                DateTime.now(),
              ),
            ),
            subtitle: Text(
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 182, 218),
              ),
              DateTime.now().year.toString(),
            ),
          ),
          // SizedBox(
          //   child: CircularPercentIndicator(
          //     radius: 80.0,
          //     progressColor: const Color.fromARGB(255, 0, 182, 218),
          //     lineWidth: 30.0,
          //     animation: true,
          //     circularStrokeCap: CircularStrokeCap.round,
          //     percent: percent,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: RichText(
              text: TextSpan(
                text: budgetSpent.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 0, 182, 218),
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: '/',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: monthlyBudget.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.editBudget,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Budget',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 182, 218),
                          ),
                        ),
                        content: TextField(
                          controller: budgetTextController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintText: "Enter amount",
                            suffix: Text("\$"),
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 182, 218),
                            ),
                            onPressed: () {
                              createNewBudget(limit);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 182, 218),
                ),
                child: Text(
                  (limit.value == null) ? "Create budget" : "Edit budget",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  createNewBudget(AsyncValue<Budget?> limit) {
    try {
      if (limit.value == null) {
        ref
            .read(expenseBudgetProvider.notifier)
            .create(double.parse(budgetTextController.text));
      } else {
        Budget? budget = switch (limit) {
          AsyncData(:final value) => value!,
          AsyncError() => null,
          _ => null,
        };
        if (budget != null) {
          budget.amount = double.parse(budgetTextController.text);
          ref.read(expenseBudgetProvider.notifier).editBudget(budget);
        }
      }
    } on IsarError catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    Navigator.pop(context);
  }
}
