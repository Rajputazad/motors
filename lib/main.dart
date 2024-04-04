import 'package:flutter/material.dart';
import 'package:motors/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor:
                Colors.white, // Set the AppBar background color here
          ),
          // Define your theme properties here
          primaryColor: Colors.blue,
          colorScheme: const ColorScheme.light(
            secondary: Colors.blue, // Define your accent color here
          )),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'Gajanand motors',
      home: const Home(),
    );
  }
}
