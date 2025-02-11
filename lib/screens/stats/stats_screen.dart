import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/analytics_service.dart';
import '../../services/localization_service.dart';
import '../../services/project_service.dart';
import 'widgets/stats_card.dart';
import 'widgets/progress_chart.dart';

class StatsScreen extends StatelessWidget {
  final AnalyticsService _analyticsService = AnalyticsService();

  StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(localization.translate('statistics')),
              bottom: TabBar(
                tabs: [
                  Tab(text: localization.translate('overview')),
                  Tab(text: localization.translate('details')),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildOverviewTab(context),
                _buildDetailsTab(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return FutureBuilder(
          future: context.read<ProjectService>().getProjects(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final stats = _analyticsService.getProjectStats(snapshot.data!);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                StatsCard(
                  title: localization.translate('total_projects'),
                  value: stats['totalProjects'].toString(),
                  icon: Icons.folder,
                ),
                const SizedBox(height: 16),
                StatsCard(
                  title: localization.translate('completed_projects'),
                  value: stats['completedProjects'].toString(),
                  icon: Icons.check_circle,
                ),
                const SizedBox(height: 16),
                ProgressChart(
                  data: stats['monthlyProgress'],
                  title: localization.translate('monthly_progress'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    // Implementation of _buildDetailsTab method
    return Container(); // Placeholder, actual implementation needed
  }
}
