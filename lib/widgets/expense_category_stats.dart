import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/util/config.dart';
import 'package:expense_tracker/widgets/expense_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ExpenseCategoryStats extends ConsumerWidget {
  const ExpenseCategoryStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<double> total = ref.watch(expenseMainProvider);
    final AsyncValue<List<double>> sumByCategory =
        ref.watch(expenseCategoryProvider);

    return Card(
      child: Column(
        children: [
          const TitleWidget(
            title: "Expenses / Category",
            titleColor: Color.fromARGB(255, 0, 182, 218),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Column(
            children: spendIndicator(sumByCategory, total),
          ),
        ],
      ),
    );
  }

  List<Widget> spendIndicator(
      AsyncValue<List<double>> sumByCategory, AsyncValue<double> total) {
    List<Widget> indicators = [];

    final all = switch (total) {
      AsyncData(:final value) => value,
      AsyncError() => 0,
      _ => 0
    };

    for (int i = 0; i < categories.length; i++) {
      final sum = switch (sumByCategory) {
        AsyncData(:final value) => value[i],
        AsyncError() => 0,
        _ => 0,
      };

      indicators.add(LinearPercentIndicator(
        animation: true,
        curve: Curves.bounceIn,
        width: 140.0,
        lineHeight: 7.0,
        percent: sum / all,
        backgroundColor: Colors.white70,
        progressColor: const Color.fromARGB(255, 0, 182, 218),
        trailing: Text(categories[i]["name"]),
      ));
    }
    return indicators;
  }
}
