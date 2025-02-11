import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/localization_service.dart';

class EmptyState extends StatelessWidget {
  final String type; // 'counters', 'patterns', 'projects'
  final VoidCallback onCreate;

  const EmptyState({
    super.key,
    required this.type,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(),
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                localization.translate('no_${type}_title'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[800],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                localization.translate('create_$type'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIcon() {
    switch (type) {
      case 'counters':
        return Icons.timer_outlined;
      case 'patterns':
        return Icons.pattern_outlined;
      case 'projects':
        return Icons.work_outline;
      default:
        return Icons.add_circle_outline;
    }
  }
}
