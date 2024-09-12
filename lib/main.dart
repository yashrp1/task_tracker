import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/provider/task_provider.dart';
import 'package:task_tracker/ui/task_list_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskProvider()..loadTasks(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple, // Set primary color to purple
        scaffoldBackgroundColor: Colors.white, // Set default background color to white
        appBarTheme: const AppBarTheme(
          color: Colors.purple, // AppBar color
          iconTheme: IconThemeData(color: Colors.white), // Icons in AppBar will be white
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // AppBar title style
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), // Default text color is black
          bodyMedium: TextStyle(color: Colors.black), // Body text color
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: Colors.white, // Input field background color is white
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple, // Button background color is purple
            foregroundColor: Colors.white, // Button text color is white
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple, // FAB color
          foregroundColor: Colors.white, // FAB icon color
        ),
      ),
      home: const TaskListScreen(),
    );
  }
}
