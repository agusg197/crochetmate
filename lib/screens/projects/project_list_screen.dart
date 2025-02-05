import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../services/project_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/project_card.dart';
import 'project_detail_screen.dart';
import 'package:provider/provider.dart';
import '../../services/localization_service.dart';
import '../../widgets/custom_refresh_indicator.dart';
import '../../widgets/skeleton_loader.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late ProjectService _projectService;
  List<Project> _projects = [];
  bool _isLoading = true;
  ProjectStatus? _selectedStatus;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _projectService = ProjectService(prefs);
    await _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _isLoading = true);
    _projects = await _projectService.filterProjects(
      status: _selectedStatus,
      searchQuery: _searchQuery,
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _createProject() async {
    debugPrint('Creando nuevo proyecto...');
    final result = await Navigator.push<Project>(
      context,
      MaterialPageRoute(
        builder: (context) => const ProjectDetailScreen(),
      ),
    );

    if (result != null) {
      await _projectService.saveProject(result);
      _loadProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localization.translate('projects')),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: localization.translate('search_projects'),
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _loadProjects();
                    });
                  },
                ),
              ),
              if (_selectedStatus != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(_selectedStatus!.displayName),
                    onDeleted: () {
                      setState(() {
                        _selectedStatus = null;
                        _loadProjects();
                      });
                    },
                  ),
                ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _projects.isEmpty
                        ? _buildEmptyState(localization)
                        : _buildProjectGrid(localization),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createProject,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(LocalizationService localization) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            localization.translate('no_projects'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            localization.translate('create_project'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectGrid(LocalizationService localization) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        return ProjectCard(
          project: _projects[index],
          onTap: () => _openProject(_projects[index]),
          index: index,
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ProjectStatus.values.map((status) {
            return ListTile(
              title: Text(status.displayName),
              leading: Icon(Icons.circle, color: status.color),
              onTap: () {
                setState(() {
                  _selectedStatus = status;
                  _loadProjects();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _openProject(Project project) async {
    final result = await Navigator.push<Project>(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(project: project),
      ),
    );

    if (result != null) {
      await _projectService.saveProject(result);
      _loadProjects();
    }
  }
}
