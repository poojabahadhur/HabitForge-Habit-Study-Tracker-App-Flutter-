import 'package:isar/isar.dart';
part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;
  late String name;
  // store normalized date-only DateTime entries for completed days
  List<DateTime> completedDays = [];
}
