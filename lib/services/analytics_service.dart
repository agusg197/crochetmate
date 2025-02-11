import '../models/project.dart';
import '../models/counter.dart';

class AnalyticsService {
  Map<String, dynamic> getProjectStats(List<Project> projects) {
    final totalProjects = projects.length;
    final completedProjects =
        projects.where((p) => p.status == ProjectStatus.completed).length;
    final inProgressProjects =
        projects.where((p) => p.status == ProjectStatus.inProgress).length;

    // Calcular tiempo promedio de finalización
    final completedProjectsDuration = projects
        .where(
            (p) => p.status == ProjectStatus.completed && p.updatedAt != null)
        .map((p) => p.updatedAt!.difference(p.createdAt).inDays)
        .toList();

    final averageCompletionTime = completedProjectsDuration.isNotEmpty
        ? completedProjectsDuration.reduce((a, b) => a + b) /
            completedProjectsDuration.length
        : 0;

    return {
      'totalProjects': totalProjects,
      'completedProjects': completedProjects,
      'inProgressProjects': inProgressProjects,
      'averageCompletionTime': averageCompletionTime,
      'projectsByStatus': _getProjectsByStatus(projects),
      'monthlyProgress': _getMonthlyProgress(projects),
    };
  }

  Map<ProjectStatus, int> _getProjectsByStatus(List<Project> projects) {
    return {
      for (var status in ProjectStatus.values)
        status: projects.where((p) => p.status == status).length
    };
  }

  List<Map<String, dynamic>> _getMonthlyProgress(List<Project> projects) {
    final now = DateTime.now();
    final sixMonthsAgo = now.subtract(const Duration(days: 180));

    // Ordenar proyectos por fecha
    final sortedProjects = projects
        .where((p) => p.createdAt.isAfter(sixMonthsAgo))
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Agrupar por mes y calcular progreso promedio
    final monthlyData = <DateTime, List<double>>{};

    for (var project in sortedProjects) {
      final date = DateTime(project.createdAt.year, project.createdAt.month);
      monthlyData.putIfAbsent(date, () => []);
      monthlyData[date]!.add(project.progress);
    }

    return monthlyData.entries.map((entry) {
      final avgProgress = entry.value.isEmpty
          ? 0.0
          : entry.value.reduce((a, b) => a + b) / entry.value.length;

      return {
        'date': entry.key,
        'progress': avgProgress,
        'projectCount': entry.value.length,
      };
    }).toList();
  }
}
