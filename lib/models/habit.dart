import 'package:isar/isar.dart';

// the file that is going to be generated
part 'habit.g.dart';

@Collection()
class Habit {
  // we gonna have the id
  Id id = Isar.autoIncrement;

  // the habit name
  late String name;

  // and the completed days
  List<DateTime> completedDays = [];
  // DateTime(year, month, day)
}
