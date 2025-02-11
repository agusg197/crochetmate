import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailedStatsCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final List<Color> colors;

  const DetailedStatsCard({
    super.key,
    required this.title,
    required this.data,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _createSections(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createSections() {
    return data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value,
        title: '${(entry.value * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.entries.map((entry) {
        final index = data.keys.toList().indexOf(entry.key);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(entry.key),
          ],
        );
      }).toList(),
    );
  }
}
