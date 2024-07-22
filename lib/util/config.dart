const List<Map<String, dynamic>> categories = [
  {"name": "Bills", "icon": "assets/images/bill.png", "selected": false},
  {"name": "Food", "icon": "assets/images/food.png", "selected": false},
  {"name": "Clothes", "icon": "assets/images/clothes.png", "selected": false},
  {
    "name": "Transport",
    "icon": "assets/images/transport.png",
    "selected": false
  },
  {"name": "Fun", "icon": "assets/images/fun.png", "selected": false},
  {"name": "Others", "icon": "assets/images/others.png", "selected": false}
];

List<String> paymentMethods = ["Cash", "Credit card", "Bank account", ""];

List<String> filterOptions = [
  "Category",
  "Amount Range",
  "Amount",
  "Category and Amount",
  "Not Others Category",
  "Group Filter",
  "Payment Method",
  "Any Selected Category",
  "All Selected Category",
  "Sub Category",
  "Receipt",
  "Pagination",
  "Insertion"
];

enum Filterby {
  category,
  amountrange,
  amount,
  categoryAndAmount,
  notOthers,
  groupFilter,
  paymentMethod,
  anySelectedCategory,
  allSelectedCategory,
  subCat,
  receipt,
  pagination,
  insertion
}

enum Amountfilter { greaterThan, lessThan }

enum Orderfilter { findfirst, deletefirst }
