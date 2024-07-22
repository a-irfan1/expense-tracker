import 'package:expense_tracker/collections/expense.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/util/config.dart';
import 'package:expense_tracker/widgets/expense_category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Filter extends ConsumerStatefulWidget {
  const Filter({super.key});

  @override
  ConsumerState createState() => _FilterState();

  static const routeName = "/filter";
}

class _FilterState extends ConsumerState<Filter> {
  int selectedItem = 0;
  Amountfilter? groupValue;
  final TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final TextEditingController searchController = TextEditingController();
  List<int> selectedItems = [];
  int dropdown = 0;
  int offset = 0;
  Orderfilter? insertionOrder;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as FilterArguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter by ${args.filterBy.name}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 182, 218),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                filterByCategory(args),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Visibility filterByCategory(FilterArguments args) {
    return Visibility(
      visible: (args.filterBy == Filterby.category),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedItem = index;
              });

              ref
                  .read(expenseFilterProvider.notifier)
                  .filterByCategory(Categories.values[index]);
            },
            child: ExpenseCategoryItem(
              index: index,
              selectedItem: selectedItem,
            ),
          );
        },
      ),
    );
  }

  Visibility filterByAmountRange(
      FilterArguments args, BuildContext context, WidgetRef ref) {
    final filterFormKey = GlobalKey<FormState>();
    final TextEditingController lowValueController = TextEditingController();
    final TextEditingController highValueController = TextEditingController();

    return Visibility(
      visible: (args.filterBy == Filterby.amountrange),
      child: Column(
        children: [
          Form(
            key: filterFormKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    controller: lowValueController,
                    decoration: const InputDecoration(hintText: "Low Value"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter lower amount";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    controller: highValueController,
                    decoration: const InputDecoration(hintText: "High Value"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter higher amount";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    lowValueController.clear();
                    highValueController.clear();
                    ref.read(expenseFilterProvider.notifier).resetResults();
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    foregroundColor: const Color.fromARGB(255, 0, 182, 218),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 0, 182, 218),
                    ),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.3, 30),
                  ),
                  child: const Text("Reset"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (filterFormKey.currentState!.validate()) {
                      ref
                          .read(expenseFilterProvider.notifier)
                          .filterByAmountRange(
                            double.parse(lowValueController.text),
                            double.parse(highValueController.text),
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 0, 182, 218),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.3, 30),
                  ),
                  child: const Text("Apply"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Visibility filterByInsertion(FilterArguments args) {
    return Visibility(
      visible: (args.filterBy == Filterby.insertion),
      child: Column(
        children: [
          RadioListTile<Orderfilter>(
              activeColor: Colors.teal,
              title: const Text("Find first"),
              value: Orderfilter.findfirst,
              groupValue: insertionOrder,
              onChanged: (Orderfilter? value) {
                setState(() {
                  insertionOrder = value!;
                });
                ref.read(expenseFilterProvider.notifier).filterByFindingFirst();
              }),
          RadioListTile<Orderfilter>(
              activeColor: Colors.teal,
              title: const Text("Delete first"),
              value: Orderfilter.deletefirst,
              groupValue: insertionOrder,
              onChanged: (Orderfilter? value) {
                setState(() {
                  insertionOrder = value!;
                });
                ref
                    .read(expenseFilterProvider.notifier)
                    .filterByDeletingFirst();
              }),
        ],
      ),
    );
  }

  Visibility filterByPagination(FilterArguments args, BuildContext context) {
    return Visibility(
        visible: (args.filterBy == Filterby.pagination),
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () {
                ref
                    .read(expenseFilterProvider.notifier)
                    .filterByPagination(offset);
                setState(() {
                  offset += 3;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: const StadiumBorder(),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 30)),
              child: const Text("Display items (3 items)")),
        ));
  }

  Visibility filterByReceipt(FilterArguments args, BuildContext context) {
    return Visibility(
        visible: (args.filterBy == Filterby.receipt),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: "Search Receipt name",
                    hintStyle: TextStyle(color: Colors.teal)),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    ref
                        .read(expenseFilterProvider.notifier)
                        .filterByReceipt(searchController.text);
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.teal,
                ))
          ],
        ));
  }

  Visibility filterBySubCategory(FilterArguments args, BuildContext context) {
    return Visibility(
        visible: (args.filterBy == Filterby.subCat),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: "Search sub category",
                    hintStyle: TextStyle(color: Colors.teal)),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    ref
                        .read(expenseFilterProvider.notifier)
                        .filterBySubCategory(searchController.text);
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.teal,
                ))
          ],
        ));
  }

  Visibility filterByAllSelectedCategory(FilterArguments args) {
    return Visibility(
        visible: (args.filterBy == Filterby.allSelectedCategory),
        child: Column(children: [
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 4.0),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedItems.contains(index)) {
                        selectedItems.remove(index);
                      } else {
                        selectedItems.add(index);
                      }
                    });
                  },
                  child: Card(
                    color: selectedItems.contains(index)
                        ? const Color(0xFFA4D6D1)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/${categories[index]["icon"]!}",
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            categories[index]["name"]!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedItems.contains(index)
                                    ? Colors.teal
                                    : const Color.fromRGBO(155, 162, 161, 1),
                                fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                    });
                    ref.read(expenseFilterProvider.notifier).resetResults();
                  },
                  style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 30)),
                  child: const Text("Reset"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      List<Categories> categories = [];
                      for (int selectedItem in selectedItems) {
                        categories.add(Categories.values[selectedItem]);
                      }

                      ref
                          .read(expenseFilterProvider.notifier)
                          .filterByUsingAll(categories);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text("Apply"))
              ]))
        ]));
  }

  Visibility filterByAnySelectedCategory(FilterArguments args) {
    return Visibility(
        visible: (args.filterBy == Filterby.anySelectedCategory),
        child: Column(children: [
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 4.0),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedItems.contains(index)) {
                        selectedItems.remove(index);
                      } else {
                        selectedItems.add(index);
                      }
                    });
                  },
                  child: Card(
                    color: selectedItems.contains(index)
                        ? const Color(0xFFA4D6D1)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/${categories[index]["icon"]!}",
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            categories[index]["name"]!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedItems.contains(index)
                                    ? Colors.teal
                                    : const Color.fromRGBO(155, 162, 161, 1),
                                fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                    });
                    ref.read(expenseFilterProvider.notifier).resetResults();
                  },
                  style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 30)),
                  child: const Text("Reset"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      List<Categories> categories = [];
                      for (int selectedItem in selectedItems) {
                        categories.add(Categories.values[selectedItem]);
                      }

                      ref
                          .read(expenseFilterProvider.notifier)
                          .filterByUsingAny(categories);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text("Apply"))
              ]))
        ]));
  }

  Visibility filterByPaymentMethod(FilterArguments args) {
    return Visibility(
        visible: (args.filterBy == Filterby.paymentMethod),
        child: TextField(
          controller: searchController,
          onChanged: (String? value) {
            if (value == null) {
              ref.read(expenseFilterProvider.notifier).resetResults();
            } else {
              ref
                  .read(expenseFilterProvider.notifier)
                  .filterByPaymentMethod(value);
            }
          },
        ));
  }

  Visibility filterByGroupFilter(FilterArguments args, BuildContext context) {
    return Visibility(
        visible: (args.filterBy == Filterby.groupFilter),
        child: Column(
          children: [
            const Text("Category: Others"),
            ListTile(
                subtitle: Text(DateFormat("d MMM yyyy").format(selectedDate)),
                trailing: IconButton(
                    onPressed: () async {
                      selectedDate = (await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030))) ??
                          DateTime.now();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.teal,
                    ))),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search text",
                  hintStyle: TextStyle(fontSize: 13, color: Colors.teal)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        selectedDate = DateTime.now();
                        searchController.clear();
                        ref.read(expenseFilterProvider.notifier).resetResults();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text("Reset")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (searchController.text.isNotEmpty) {
                          ref
                              .read(expenseFilterProvider.notifier)
                              .filterByGroupFilter(
                                  searchController.text, selectedDate);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: const StadiumBorder(),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text("Apply"))
                ],
              ),
            ),
          ],
        ));
  }

  Visibility filterByNotOthersCategory(FilterArguments args) {
    return Visibility(
      visible: (args.filterBy == Filterby.notOthers),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  ref.read(expenseFilterProvider.notifier).resetResults();
                },
                style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.3, 30)),
                child: const Text("Reset")),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  ref
                      .read(expenseFilterProvider.notifier)
                      .filterByNotOthersCategory();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: const StadiumBorder(),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.3, 30)),
                child: const Text("Apply"))
          ],
        ),
      ),
    );
  }

  Visibility filterByCategoryAndAmount(FilterArguments args) {
    return Visibility(
      visible: (args.filterBy == Filterby.categoryAndAmount),
      child: Column(
        children: [
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 4.0),
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
              }),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: TextField(
              controller: amountController,
              decoration: const InputDecoration(
                  hintText: "Amount greater than ...",
                  hintStyle: TextStyle(fontSize: 14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      amountController.clear();
                      ref.read(expenseFilterProvider.notifier).resetResults();
                    },
                    style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        foregroundColor: Colors.teal,
                        side: const BorderSide(color: Colors.teal),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text("Reset")),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (amountController.text.isNotEmpty) {
                        ref
                            .read(expenseFilterProvider.notifier)
                            .filterByAmountAndCategory(
                                Categories.values[selectedItem],
                                double.parse(amountController.text));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 30)),
                    child: const Text("Apply"))
              ],
            ),
          )
        ],
      ),
    );
  }

  Visibility filterByAmount(FilterArguments args) {
    final TextEditingController amountController = TextEditingController();

    return Visibility(
        visible: (args.filterBy == Filterby.amount),
        child: Column(
          children: [
            RadioListTile<Amountfilter>(
                activeColor: Colors.teal,
                title: const Text("Greater than"),
                value: Amountfilter.greaterThan,
                groupValue: groupValue,
                onChanged: (Amountfilter? value) {
                  setState(() {
                    groupValue = value!;
                  });
                }),
            RadioListTile<Amountfilter>(
                activeColor: Colors.teal,
                title: const Text("Less than"),
                value: Amountfilter.lessThan,
                groupValue: groupValue,
                onChanged: (Amountfilter? value) {
                  setState(() {
                    groupValue = value!;
                  });
                }),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: 'Enter amount'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        amountController.clear();
                        ref.read(expenseFilterProvider.notifier).resetResults();
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text("Reset")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (amountController.text.isNotEmpty) {
                          if (groupValue == Amountfilter.greaterThan) {
                            ref
                                .read(expenseFilterProvider.notifier)
                                .filterByAmountGreaterThan(
                                    double.parse(amountController.text));
                          } else if (groupValue == Amountfilter.lessThan) {
                            ref
                                .read(expenseFilterProvider.notifier)
                                .filterByAmountLessThan(
                                    double.parse(amountController.text));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: const StadiumBorder(),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.3, 30)),
                      child: const Text("Apply"))
                ],
              ),
            )
          ],
        ));
  }
}

class FilterArguments {
  final Filterby filterBy;

  FilterArguments({required this.filterBy});
}
