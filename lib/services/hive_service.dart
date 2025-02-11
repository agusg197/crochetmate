import 'package:hive_flutter/hive_flutter.dart';
import '../models/project.dart';
import '../models/counter.dart';
import '../models/pattern.dart';

class HiveService {
  static const String projectsBox = 'projects';
  static const String countersBox = 'counters';
  static const String patternsBox = 'patterns';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProjectAdapter());
    Hive.registerAdapter(ProjectStatusAdapter());
    Hive.registerAdapter(CounterAdapter());
    Hive.registerAdapter(PatternAdapter());

    await Hive.openBox<Project>(projectsBox);
    await Hive.openBox<Counter>(countersBox);
    await Hive.openBox<Pattern>(patternsBox);
  }

  static Box<Project> getProjectsBox() {
    return Hive.box<Project>(projectsBox);
  }

  static Future<void> saveProject(Project project) async {
    final box = getProjectsBox();
    await box.put(project.id, project);
  }

  static Future<List<Project>> getAllProjects() async {
    final box = getProjectsBox();
    return box.values.toList();
  }

  static Future<void> deleteProject(String id) async {
    final box = getProjectsBox();
    await box.delete(id);
  }

  static Future<void> clearAll() async {
    final box = getProjectsBox();
    await box.clear();
  }
}
