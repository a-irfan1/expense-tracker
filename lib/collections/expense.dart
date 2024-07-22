import 'package:expense_tracker/collections/receipt.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
@CustomSubCategoryConverter()
@Collection()
class Expense {
  Expense();

  Id id = Isar.autoIncrement;

  @Index()
  late double amount;

  @Index()
  late DateTime date;

  @Enumerated(EnumType.name)
  Categories? category;

  SubCategory? subCategory;

  final receipts = IsarLinks<Receipt>();

  @Index(composite: [CompositeIndex('amount')])
  String? paymentMethod;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

enum Categories {
  bills,
  transport,
  entertainment,
  shopping,
  food,
  others,
}

@Embedded()
class SubCategory {
  String? name;
}

class CustomSubCategoryConverter implements JsonConverter<SubCategory, String> {
  const CustomSubCategoryConverter();

  @override
  SubCategory fromJson(String json) {
    return SubCategory()..name = json;
  }

  @override
  String toJson(SubCategory object) => object.name!;
}
