import 'package:flutter/material.dart';
import '../screens/counter/counter_list_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/patterns/pattern_list_screen.dart';
import '../screens/projects/project_list_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String patterns = '/patterns';
  static const String projects = '/projects';
  static const String settings = '/settings';
  static const String counters = '/counters';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      patterns: (context) => const PatternListScreen(),
      projects: (context) => const ProjectListScreen(),
      settings: (context) => const SettingsScreen(),
      counters: (context) => const CounterListScreen(),
    };
  }
}
