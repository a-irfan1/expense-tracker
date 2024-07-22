import 'package:isar/isar.dart';

part 'income.g.dart';

@Collection()
class Income {
  Id id = Isar.autoIncrement;

  late String name;
}
