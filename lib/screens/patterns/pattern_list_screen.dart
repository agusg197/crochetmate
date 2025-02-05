import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/pattern.dart';
import '../../services/pattern_service.dart';
import '../../services/localization_service.dart';
import '../../widgets/responsive_layout.dart';
import './pattern_detail_screen.dart';
import '../../widgets/language_button.dart';

class PatternListScreen extends StatefulWidget {
  const PatternListScreen({super.key});

  @override
  State<PatternListScreen> createState() => _PatternListScreenState();
}

class _PatternListScreenState extends State<PatternListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final PatternService _patternService;
  List<Pattern> _patterns = [];
  bool _isLoading = true;
  String? _selectedDifficulty;

  final List<String> _difficultyLevels = [
    'Principiante',
    'Intermedio',
    'Avanzado',
  ];

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _patternService = PatternService(prefs);
    _loadPatterns();
  }

  Future<void> _loadPatterns() async {
    setState(() => _isLoading = true);

    try {
      final patterns = await _patternService.searchPatterns(
        _searchController.text,
        difficulty: _selectedDifficulty,
      );

      setState(() {
        _patterns = patterns;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los patrones')),
      );
      setState(() => _isLoading = false);
    }
  }

  void _createPattern() async {
    final result = await Navigator.push<Pattern>(
      context,
      MaterialPageRoute(builder: (context) => const PatternDetailScreen()),
    );

    if (result != null) {
      await _patternService.savePattern(result);
      _loadPatterns();
    }
  }

  void _showFilterDialog(
    BuildContext context,
    LocalizationService localization,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localization.translate('filter_by_difficulty')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(localization.translate('all')),
              onTap: () {
                setState(() => _selectedDifficulty = null);
                Navigator.pop(context);
                _loadPatterns();
              },
            ),
            ..._difficultyLevels.map((difficulty) {
              return ListTile(
                title: Text(difficulty),
                onTap: () {
                  setState(() => _selectedDifficulty = difficulty);
                  Navigator.pop(context);
                  _loadPatterns();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localization.translate('patterns')),
            actions: [const LanguageButton()],
          ),
          body: ResponsiveLayout(
            mobile: _buildMobileLayout(localization),
            tablet: _buildTabletLayout(localization),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createPattern,
            tooltip: localization.translate('new_pattern'),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(LocalizationService localization) {
    return Column(
      children: [
        _buildSearchBar(localization),
        Expanded(child: _buildPatternListView(localization)),
      ],
    );
  }

  Widget _buildTabletLayout(LocalizationService localization) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildSearchBar(localization),
              Expanded(child: _buildPatternListView(localization)),
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 2,
          child: Center(child: Text(localization.translate('select_pattern'))),
        ),
      ],
    );
  }

  Widget _buildSearchBar(LocalizationService localization) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: localization.translate('search_patterns'),
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) => _loadPatterns(),
      ),
    );
  }

  Widget _buildPatternListView(LocalizationService localization) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_patterns.isEmpty) {
      return _buildEmptyState(localization);
    }

    return ListView.builder(
      itemCount: _patterns.length,
      itemBuilder: (context, index) {
        final pattern = _patterns[index];
        return ListTile(
          title: Text(pattern.name),
          subtitle: Text(localization.translate(pattern.difficulty)),
          onTap: () => _editPattern(pattern),
        );
      },
    );
  }

  Widget _buildEmptyState(LocalizationService localization) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pattern, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            localization.translate('no_patterns'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            localization.translate('create_pattern'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _editPattern(Pattern pattern) {
    // Implement the logic to edit a pattern
  }
}
