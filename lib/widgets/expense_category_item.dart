import 'package:flutter/material.dart';
import 'package:expense_tracker/util/config.dart';

class ExpenseCategoryItem extends StatelessWidget {
  const ExpenseCategoryItem(
      {super.key, required this.index, required this.selectedItem});

  final int index;
  final int selectedItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (index == selectedItem) ? const Color(0xffA4D6D1) : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            '${categories[index]["icon"]}',
            width: 40,
          ),
          Text(
            categories[index]['name'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: (index == selectedItem)
                  ? const Color.fromARGB(255, 0, 182, 218)
                  : const Color.fromRGBO(155, 162, 161, 1),
            ),
          )
        ],
      ),
    );
  }
}
