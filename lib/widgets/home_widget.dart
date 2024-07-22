import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:expense_tracker/widgets/expense_title.dart';
import 'package:expense_tracker/widgets/expenses_header.dart';
import 'expense_date.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/util/functions.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key, required this.views});

  final Map<int, bool> views;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with Functions {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.views[0]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Expense Tracker',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 182, 218),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              (loading)
                  ? const CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 182, 218))
                  : IconButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await exportDataToFirebase();
                        setState(() {
                          loading = false;
                        });
                      },
                      icon: const Icon(Icons.sync),
                    ),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/search");
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          const HeaderWidget(
            editBudget: true,
          ),
          const TitleWidget(title: "Expenses", titleColor: Colors.black),
          ExpenseDate(
              date: DateFormat.d().format(DateTime.now()),
              day: DateFormat.EEEE().format(DateTime.now())),
          const ExpenseListWidget(
            showAll: false,
            filter: false,
          ),
        ],
      ),
    );
  }
}
