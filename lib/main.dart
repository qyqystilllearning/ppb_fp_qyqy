import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // We expose a static method to allow switching themes globally!
  static void switchTheme(BuildContext context, bool isDarkMode) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeTheme(isDarkMode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Bonus Feature: Dark/Light Mode
  bool isDarkMode = false;

  void changeTheme(bool dark) {
    setState(() {
      isDarkMode = dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const Scaffold(
        body: Center(
          child: Text('To-Do List Architecture Ready!'),
        ),
      ),
    );
  }
}