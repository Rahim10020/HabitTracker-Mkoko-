import 'package:flutter/material.dart';
import 'package:pro3_flutter/components/my_drawer.dart';
import 'package:pro3_flutter/components/my_habit_tile.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: _buildHabitList(),
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
        );
      },
    );
  }
}
