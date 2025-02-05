import 'package:flutter/material.dart';
import 'package:pro3_flutter/database/habit_database.dart';
import 'package:pro3_flutter/pages/home_page.dart';
import 'package:pro3_flutter/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // we gonna initialize the database
  await HabitDatabase.initialize();
  // and we gonna save the first launch date
  await HabitDatabase().saveFirstLaunchDate();
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
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
