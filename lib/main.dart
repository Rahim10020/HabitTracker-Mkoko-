import 'package:R_HabitTracker/database/habit_database.dart';
import 'package:R_HabitTracker/pages/root_shell.dart';
import 'package:R_HabitTracker/services/notification_service.dart';
import 'package:R_HabitTracker/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // we gonna initialize the database
  await HabitDatabase.initialize();
  // and we gonna save the first launch date
  await HabitDatabase().saveFirstLaunchDate();
  // and we gonna set up local notifications for habit reminders
  await NotificationService.instance.initialize();
  runApp(MultiProvider(
    providers: [
      // habit provider
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      // theme provider
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RootShell(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
