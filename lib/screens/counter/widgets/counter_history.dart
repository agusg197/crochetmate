import 'package:flutter/material.dart';
import '../../../models/counter_history_item.dart';

class CounterHistory extends StatelessWidget {
  final List<CounterHistoryItem> history;
  final Function(CounterHistoryItem) onAddNote;

  const CounterHistory({
    super.key,
    required this.history,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(
            children: const [
              Icon(Icons.history),
              SizedBox(width: 8),
              Text(
                'Historial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: history.isEmpty
              ? const Center(
                  child: Text('No hay historial'),
                )
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(item.count.toString()),
                      ),
                      title: Text(item.action),
                      subtitle: Text(
                        _formatTimestamp(item.timestamp),
                      ),
                      trailing: Text(
                        'Vuelta ${item.count}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _addNote(item),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  void _addNote(CounterHistoryItem item) {
    // Implementation of _addNote method
  }
}
