import 'dart:ffi';

import 'package:expense_tracker/util/config.dart';
import 'package:flutter/material.dart';

import 'expense_filter.dart';

class FilterBy extends StatefulWidget {
  const FilterBy({super.key});

  @override
  State<FilterBy> createState() => _FilterByState();
}

class _FilterByState extends State<FilterBy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter By",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 0, 182, 218),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        size: 30,
                        color: Color.fromARGB(255, 0, 182, 218),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: filterResults(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> filterResults() {
    List<Widget> options = [];

    for (int i = 0; i < filterOptions.length; i++) {
      options.add(Card(
        child: ListTile(
          title: Text(filterOptions[i]),
          onTap: () {
            Navigator.pushNamed(context, Filter.routeName,
                arguments: FilterArguments(filterBy: Filterby.values[i]));
          },
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Color.fromARGB(255, 0, 182, 218),
          ),
        ),
      ));
    }
    return options;
  }
}
