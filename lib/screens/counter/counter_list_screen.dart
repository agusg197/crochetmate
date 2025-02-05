import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/counter.dart';
import '../../services/counter_service.dart';
import 'counter_screen.dart';
import 'widgets/new_counter_dialog.dart';
import 'package:provider/provider.dart';
import '../../services/localization_service.dart';

class CounterListScreen extends StatefulWidget {
  const CounterListScreen({super.key});

  @override
  State<CounterListScreen> createState() => _CounterListScreenState();
}

class _CounterListScreenState extends State<CounterListScreen> {
  late CounterService _counterService;
  List<Counter> _counters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _counterService = CounterService(prefs);
    await _loadCounters();
  }

  Future<void> _loadCounters() async {
    final counters = await _counterService.getCounters();
    setState(() {
      _counters = counters;
      _isLoading = false;
    });
  }

  Future<void> _createCounter(LocalizationService localization) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => NewCounterDialog(),
    );

    if (name != null && name.isNotEmpty) {
      final counter = Counter(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
      );
      await _counterService.saveCounter(counter);
      await _loadCounters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localization.translate('counters')),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _counters.isEmpty
                  ? _buildEmptyState(localization)
                  : _buildCounterList(localization),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _createCounter(localization),
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
            Icons.timer_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            localization.translate('no_counters'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            localization.translate('create_one_new'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterList(LocalizationService localization) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _counters.length,
      itemBuilder: (context, index) {
        final counter = _counters[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(counter.count.toString()),
            ),
            title: Text(counter.name),
            subtitle: Text(
              'Promedio: ${_formatDuration(
                Duration(seconds: counter.averageTimePerRound.round()),
              )} por vuelta',
            ),
            trailing: counter.isRunning
                ? const Icon(Icons.timer, color: Colors.green)
                : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CounterScreen(counter: counter),
                ),
              ).then((_) => _loadCounters());
            },
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
