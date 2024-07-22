import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 182, 218),
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search expenses....",
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: ((value) {
            ref
                .read(expenseFilterProvider.notifier)
                .filterBySubCategory(searchController.text);
          }),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10.0),
        child: ExpenseListWidget(
          filter: true,
          showAll: true,
        ),
      ),
    );
  }
}
