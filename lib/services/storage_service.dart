import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class StorageService {
  static const String projectsKey = 'projects';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveProject(Project project) async {
    final projects = await getProjects();
    projects.add(project);
    final projectsJson = projects.map((p) => p.toJson()).toList();
    await _prefs.setString(projectsKey, projectsJson.toString());
  }

  Future<List<Project>> getProjects() async {
    final projectsString = _prefs.getString(projectsKey);
    if (projectsString == null) return [];

    final projectsJson =
        List<Map<String, dynamic>>.from(projectsString as List);
    return projectsJson.map((json) => Project.fromJson(json)).toList();
  }
}
