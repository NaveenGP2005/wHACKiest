import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:whackiest/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load theme preference from localStorage
  void _loadThemePreference() {
    final isDarkMode = html.window.localStorage['isDarkMode'] == 'true';
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Toggle theme based on user input
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    html.window.localStorage['isDarkMode'] = isDark.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: _themeMode, // Set the current theme mode
      home: SplashScreen(), // Initial screen
    );
  }
}
