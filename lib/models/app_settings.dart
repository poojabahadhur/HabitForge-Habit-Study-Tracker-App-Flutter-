import 'package:isar/isar.dart';
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;

  // first launch date (existing)
  DateTime? FirstLaunchDate;

  // new: track when popup was last shown (normalized date)
  DateTime? LastPopupShownDate;
}
