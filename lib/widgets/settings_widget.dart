import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

import '../util/functions.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key, required this.views});

  final Map<int, bool> views;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> with Functions {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.views[4]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 182, 218),
            ),
          ),
          const Text("Currency"),
          ListTile(
            onTap: () {
              showCurrencyPicker(
                context: context,
                showFlag: true,
                showSearchField: true,
                showCurrencyName: true,
                showCurrencyCode: true,
                favorite: ['pkr'],
                onSelect: (Currency currency) {},
              );
            },
            leading: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 0, 182, 218),
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "€",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: const Text(
              "Euro",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 182, 218),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 5),
                ),
                onPressed: () {
                  clearData();
                  setState(() {});
                },
                child: const Text("Clear Data"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
