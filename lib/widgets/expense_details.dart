import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/util/config.dart';
import 'package:expense_tracker/util/functions.dart';
import 'package:expense_tracker/widgets/expense_divider.dart';
import 'package:expense_tracker/widgets/expense_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetail extends StatefulWidget {
  const ExpenseDetail({super.key});

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();

  static const routeName = "/details";
}

class _ExpenseDetailState extends State<ExpenseDetail> with Functions {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ExpenseDetailArguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                DateFormat.EEEE().format(args.expense.date),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                "${DateFormat.d().format(args.expense.date)} ${DateFormat.MMM().format(args.expense.date)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 182, 218),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  size: 30,
                  color: Color.fromARGB(255, 0, 182, 218),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const ExpenseDivider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWidget(title: "Amount", titleColor: Colors.black),
                  Text(
                    "\$${args.expense.amount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 182, 218),
                    ),
                  )
                ],
              ),
            ),
            const ExpenseDivider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWidget(
                      title: "Category", titleColor: Colors.black),
                  Row(
                    children: [
                      Image.asset(
                        "assets/${categories[args.expense.category!.index]["icon"]}",
                        width: 30,
                      ),
                      Text(
                        categories[args.expense.category!.index]["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 182, 218),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const ExpenseDivider(),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: TitleWidget(title: "Receipt", titleColor: Colors.black),
            ),
            FutureBuilder(
                future: getConfigs(args),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? configs = snapshot.data;
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, mainAxisSpacing: 4.0),
                        itemCount: configs!["count"],
                        itemBuilder: (BuildContext context, int index) {
                          return Image.asset(
                            configs["path"] +
                                "/${args.expense.receipts.elementAt(index).name}",
                            width: 50,
                          );
                        });
                  } else {
                    return const Text("No data to display");
                  }
                }),
            const ExpenseDivider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWidget(
                      title: "Payment Method", titleColor: Colors.black),
                  Text(
                    args.expense.paymentMethod.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 182, 218),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseDetailArguments {
  final Expense expense;

  ExpenseDetailArguments({required this.expense});
}
