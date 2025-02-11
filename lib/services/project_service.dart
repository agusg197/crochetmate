import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../services/hive_service.dart';

class ProjectService {
  static const String _projectsKey = 'projects';
  final SharedPreferences _prefs;

  ProjectService(this._prefs);

  Future<List<Project>> getProjects() async {
    return await HiveService.getAllProjects();
  }

  Future<void> saveProject(Project project) async {
    await HiveService.saveProject(project);
  }

  Future<void> deleteProject(String id) async {
    await HiveService.deleteProject(id);
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
