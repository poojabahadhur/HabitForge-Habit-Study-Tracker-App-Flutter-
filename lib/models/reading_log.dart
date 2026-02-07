import 'package:isar/isar.dart';
part 'reading_log.g.dart';

@Collection()
class ReadingLog {
  Id id = Isar.autoIncrement;

  // timestamp when session was saved
  DateTime dateTime = DateTime.now();

  // duration in minutes
  int durationMinutes = 0;
}
