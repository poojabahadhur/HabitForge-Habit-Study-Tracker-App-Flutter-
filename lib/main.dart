import 'package:flutter/material.dart';
import 'package:habit_modification/database/habit_database.dart';
import 'package:habit_modification/pages/home_page.dart';
import 'package:habit_modification/themes/theme.provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar DB and ensure settings exist
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitDatabase()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Modification',
      theme: themeProv.themedata,
      home: const HomePage(),
    );
  }
}
