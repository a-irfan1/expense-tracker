import 'package:expense_tracker/widgets/expenses_header.dart';
import 'package:flutter/material.dart';

import 'expense_category_stats.dart';

class GeneralStats extends StatelessWidget {
  const GeneralStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HeaderWidget(editBudget: false),
        ExpenseCategoryStats(),
      ],
    );
  }
}
