import 'package:expense_tracker/widgets/expense_general_stats.dart';
import 'package:expense_tracker/widgets/expense_log.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key, required this.views});

  final Map<int, bool> views;

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  int stats = 0;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.views[2]!,
      child: Column(
        children: [
          const Text(
            "Stats",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 182, 218),
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ToggleSwitch(
              activeBgColor: const [
                Color.fromARGB(255, 0, 182, 218),
                Color.fromARGB(255, 0, 182, 218)
              ],
              initialLabelIndex: stats,
              minWidth: MediaQuery.of(context).size.width * 0.4,
              labels: const ["General", "Expense Log"],
              totalSwitches: 2,
              onToggle: (index) {
                setState(() {
                  stats = index!;
                });
              },
            ),
          ),
          (stats == 0) ? const GeneralStats() : const ExpenseLog(),
        ],
      ),
    );
  }
}
