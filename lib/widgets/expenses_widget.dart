import 'dart:io';
import 'dart:typed_data';

import 'package:expense_tracker/collections/income.dart';
import 'package:expense_tracker/collections/receipt.dart';
import 'package:expense_tracker/util/config.dart';
import 'package:expense_tracker/widgets/expense_category_item.dart';
import 'package:expense_tracker/widgets/expense_title.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';

import '../collections/expense.dart';
import '../providers/income_provider.dart';
import '../util/functions.dart';

class ExpensesWidget extends ConsumerStatefulWidget {
  const ExpensesWidget(
      {required this.views, super.key, required this.scrollController});

  final Map<int, bool> views;
  final ScrollController scrollController;

  @override
  ConsumerState<ExpensesWidget> createState() => _ExpensesWidgetState();
}

class _ExpensesWidgetState extends ConsumerState<ExpensesWidget>
    with Functions {
  final _expenseFormKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController subCatController = TextEditingController();
  final TextEditingController filenameController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  int selectedItem = 0;
  String? dropDownValue;
  Set<Receipt> receipts = {};
  bool show = false;
  List<Uint8List> files = [];
  List<String> paymentMethod = [];

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      paymentMethod = paymentMethods;
    });
    return Visibility(
      visible: widget.views[1]!,
      child: Form(
        key: _expenseFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Expense',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 0, 182, 218),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: amountController,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter amount";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontSize: 14),
                hintText: "Enter amount",
                suffix: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    '\$',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 182, 218),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat("EEEE, d MMMM").format(selectedDate!),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 182, 218),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate!,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030),
                      );
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 0, 182, 218),
                    ),
                  )
                ],
              ),
            ),
            const TitleWidget(
              title: "Select Category",
              titleColor: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 4),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedItem = index;
                    });
                  },
                  child: ExpenseCategoryItem(
                    index: index,
                    selectedItem: selectedItem,
                  ),
                );
              },
            ),
            TextFormField(
              controller: subCatController,
              style: const TextStyle(
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Sub-Category";
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                  hintText: "Enter sub-category"),
            ),
            const TitleWidget(
                title: "Select Payment Method", titleColor: Colors.black),
            DropdownButton(
              isExpanded: true,
              value: dropDownValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items:
                  paymentMethods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropDownValue = newValue;
                });
              },
            ),
            ListTile(
              title: const TitleWidget(
                title: "Add Receipt",
                titleColor: Colors.black,
              ),
              trailing: IconButton(
                iconSize: 26,
                color: const Color.fromARGB(255, 0, 182, 218),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    setState(() {
                      show = true;
                    });
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Enter Filename",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 182, 218),
                              ),
                            ),
                            content: TextField(
                              controller: filenameController,
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => uploadFile(result),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 182, 218),
                                ),
                                child: const Text("Save"),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  filenameController.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 182, 218),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ),
            Visibility(
              visible: show,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 0, 182, 218),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: files.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.memory(files[index]);
              },
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
              ),
            ),
            const TitleWidget(title: "Notes", titleColor: Colors.black),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 182, 218),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 50)),
                  onPressed: () async {
                    if (_expenseFormKey.currentState!.validate()) {
                      await createExpense(
                        double.parse(amountController.text),
                        selectedDate!,
                        Categories.values[selectedItem],
                        subCatController.text,
                        receipts,
                        dropDownValue!,
                      );
                      if (context.mounted) {
                        StatusAlert.show(context,
                            duration: const Duration(seconds: 2),
                            title: 'Expense Tracker',
                            subtitle: 'Expense Added!',
                            configuration:
                                const IconConfiguration(icon: Icons.done),
                            maxWidth: 260);
                      }
                      resetForm();
                    }
                  },
                  child: const Text('Add'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  uploadFile(FilePickerResult result) async {
    Navigator.pop(context);
    File file = File(result.files.single.path!);
    String appDirectory = await getPath();

    List<String> fileNameAndExtensions = result.files.single.name.split(".");
    final reversed = fileNameAndExtensions.reversed.toList();

    final fileName =
        "${filenameController.text}_${DateFormat("d_MM_yyy").format(selectedDate!)}.${reversed[0]}";

    filenameController.clear();

    File newFile = await file.copy('$appDirectory/$fileName');
    Uint8List imageByBytes = await newFile.readAsBytes();
    files.add(imageByBytes);

    final receipt = Receipt()..name = fileName;
    receipts.add(receipt);

    show = false;
    setState(() {});
  }

  resetForm() {
    amountController.clear();
    subCatController.clear();
    receipts.clear();
    files.clear();
    setState(() {
      selectedDate = DateTime.now();
      selectedItem = 0;
      dropDownValue = null;
    });

    widget.scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }
}
