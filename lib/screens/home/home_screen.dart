import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import '../../services/localization_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/tutorial_service.dart';
import '../../widgets/tutorial_overlay.dart';
import '../counter/counter_list_screen.dart';
import '../patterns/pattern_list_screen.dart';
import '../projects/project_list_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _patternsKey = GlobalKey();
  final GlobalKey _countersKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _animations = List.generate(
      4,
      (index) => CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          0.6 + index * 0.1,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CrochetMate',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localization.translate('app_subtitle'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: Theme.of(context).brightness == Brightness.dark
                            ? [
                                const Color(0xFF2C1F46), // Morado oscuro
                                const Color(0xFF1A1A1A), // Casi negro
                              ]
                            : [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 1000),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    size: 60,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.8)
                                        : Colors.white.withOpacity(0.9),
                                  ),
                                  Transform.rotate(
                                    angle: -0.5,
                                    child: Icon(
                                      Icons.gesture,
                                      size: 40,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50), // Espacio para el título
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildListDelegate([
                    Container(
                      key: _projectsKey,
                      child: _buildAnimatedCard(
                        0,
                        'projects',
                        Icons.work_outline,
                        () => _navigateToScreen(const ProjectListScreen()),
                      ),
                    ),
                    Container(
                      key: _patternsKey,
                      child: _buildAnimatedCard(
                        1,
                        'patterns',
                        Icons.pattern,
                        () => _navigateToScreen(const PatternListScreen()),
                      ),
                    ),
                    Container(
                      key: _countersKey,
                      child: _buildAnimatedCard(
                        2,
                        'counters',
                        Icons.add_circle_outline,
                        () => _navigateToScreen(const CounterListScreen()),
                      ),
                    ),
                    Container(
                      key: _settingsKey,
                      child: _buildAnimatedCard(
                        3,
                        'settings',
                        Icons.settings_outlined,
                        () => _navigateToScreen(const SettingsScreen()),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard(
    int index,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ScaleTransition(
      scale: _animations[index],
      child: CustomCard(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(
              context.read<LocalizationService>().translate(title),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getSubtitle(title),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getSubtitle(String key) {
    switch (key) {
      case 'projects':
        return context.read<LocalizationService>().translate('manage_projects');
      case 'patterns':
        return context
            .read<LocalizationService>()
            .translate('explore_patterns');
      case 'counters':
        return context.read<LocalizationService>().translate('count_rounds');
      case 'settings':
        return context.read<LocalizationService>().translate('customize_app');
      default:
        return '';
    }
  }

  Future<void> _checkAndShowTutorial() async {
    final tutorialService =
        TutorialService(await SharedPreferences.getInstance());
    if (await tutorialService.shouldShowTutorial()) {
      if (!mounted) return;

      final localization = context.read<LocalizationService>();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => TutorialOverlay(
          steps: [
            TutorialStep(
              title: localization.translate('tutorial_welcome_title'),
              description: localization.translate('tutorial_welcome_desc'),
            ),
            TutorialStep(
              title: localization.translate('tutorial_projects_title'),
              description: localization.translate('tutorial_projects_desc'),
              targetKey: _projectsKey,
            ),
            TutorialStep(
              title: localization.translate('tutorial_patterns_title'),
              description: localization.translate('tutorial_patterns_desc'),
              targetKey: _patternsKey,
            ),
            TutorialStep(
              title: localization.translate('tutorial_counters_title'),
              description: localization.translate('tutorial_counters_desc'),
              targetKey: _countersKey,
            ),
            TutorialStep(
              title: localization.translate('tutorial_settings_title'),
              description: localization.translate('tutorial_settings_desc'),
              targetKey: _settingsKey,
            ),
          ],
          onComplete: () async {
            await tutorialService.markTutorialAsComplete();
            if (!mounted) return;
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
