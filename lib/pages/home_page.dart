import 'package:flutter/material.dart';
import 'package:pro3_flutter/components/my_drawer.dart';
import 'package:pro3_flutter/components/my_habit_tile.dart';
import 'package:pro3_flutter/components/my_heat_map.dart';
import 'package:pro3_flutter/database/habit_database.dart';
import 'package:pro3_flutter/models/habit.dart';
import 'package:pro3_flutter/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // we gonna read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create new habit"),
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          // save button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;
              // and save it to the database
              context.read<HabitDatabase>().addHabit(newHabitName);
              // pop the dialog
              Navigator.pop(context);
              // clear the controller
              textController.clear();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void checkHabitOnAndOff(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit box
  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          // save button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;
              // and save it to the database
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);
              // pop the dialog
              Navigator.pop(context);
              // clear the controller
              textController.clear();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // delete habit box

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          // delete button
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              // pop the dialog
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        onPressed: createNewHabit,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(children: [
        // HEATMAP
        _buildHeatMap(),
        // HABIT LIST
        _buildHabitList(),
      ]),
    );
  }

  Widget _buildHeatMap() {
    // habit database
    final habitDatabase = context.watch<HabitDatabase>();
    // get current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    // return a heatmap UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunch(),
      builder: (context, snapshot) {
        // once data is availbe -> build heat map
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(currentHabits),
          );
        }
        // handle case no data is returned
        else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    // habit database
    final habitDatabase = context.watch<HabitDatabase>();
    // current Habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    // return list of habit UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];
        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(
          habit.completedDays,
        );
        // return habit tile UI
        return MyHabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnAndOff(value, habit),
          onEditPressed: (context) => editHabitBox(habit),
          onDeletePressed: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
