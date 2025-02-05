import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class ProjectService {
  static const String _projectsKey = 'projects';
  final SharedPreferences _prefs;

  ProjectService(this._prefs);

  Future<List<Project>> getProjects() async {
    final String? data = _prefs.getString(_projectsKey);
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Project.fromJson(json)).toList();
  }

  Future<void> saveProject(Project project) async {
    final projects = await getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);

    if (index >= 0) {
      projects[index] = project;
    } else {
      projects.add(project);
    }

    await _saveProjects(projects);
  }

  Future<void> deleteProject(String id) async {
    final projects = await getProjects();
    projects.removeWhere((project) => project.id == id);
    await _saveProjects(projects);
  }

  Future<void> _saveProjects(List<Project> projects) async {
    final String data = json.encode(
      projects.map((project) => project.toJson()).toList(),
    );
    await _prefs.setString(_projectsKey, data);
  }

  Future<List<Project>> filterProjects({
    ProjectStatus? status,
    String? searchQuery,
  }) async {
    final List<Project> projects = await getProjects();
    return projects.where((project) {
      bool matchesStatus = status == null || project.status == status;
      bool matchesSearch = searchQuery == null ||
          project.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          project.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }
}
