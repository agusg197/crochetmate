import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/localization_service.dart';

import '../../../models/counter_history_item.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  final Duration? totalDuration;
  final CounterHistoryItem? lastRound;

  const CounterDisplay({
    super.key,
    required this.count,
    this.totalDuration,
    this.lastRound,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localization.translate('rounds'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (totalDuration != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${localization.translate('total_time')}: ${_formatDuration(totalDuration!)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (lastRound != null && lastRound!.roundDuration != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${localization.translate('last_round')}: ${_formatDuration(lastRound!.roundDuration!)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
