import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/counter.dart';
import '../../services/haptic_service.dart';
import 'widgets/counter_button.dart';
import 'widgets/counter_display.dart';
import '../../models/counter_history_item.dart';

import '../../services/counter_service.dart';
import 'widgets/counter_history.dart';
import '../../services/localization_service.dart';

class CounterScreen extends StatefulWidget {
  final Counter counter;

  const CounterScreen({
    super.key,
    required this.counter,
  });

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late Counter _counter;
  Timer? _timer;
  Duration _currentRoundDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _counter = widget.counter;
    if (_counter.isRunning) {
      _startTimer();
    }
  }

  void _startTimer() {
    _counter.isRunning = true;
    _counter.startTime ??= DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentRoundDuration =
            DateTime.now().difference(_counter.lastUpdateTime!);
      });
    });
  }

  void _stopTimer() {
    _counter.isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  void _increment() {
    setState(() {
      _counter.count++;
      final now = DateTime.now();
      final historyItem = CounterHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        count: _counter.count,
        action: 'Vuelta completada',
        timestamp: now,
        roundDuration: _counter.lastUpdateTime != null
            ? now.difference(_counter.lastUpdateTime!)
            : null,
      );
      _counter.history.insert(0, historyItem);
      _counter.lastUpdateTime = now;
      _currentRoundDuration = Duration.zero;
      HapticService.lightImpact();
    });
    _saveCounter();
  }

  void _decrement() {
    if (_counter.count > 0) {
      setState(() {
        _counter.count--;
        final now = DateTime.now();
        final historyItem = CounterHistoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          count: _counter.count,
          action: 'Vuelta deshecha',
          timestamp: now,
          roundDuration: _counter.lastUpdateTime != null
              ? now.difference(_counter.lastUpdateTime!)
              : null,
        );
        _counter.history.insert(0, historyItem);
        _counter.lastUpdateTime = now;
        _currentRoundDuration = Duration.zero;
        HapticService.lightImpact();
      });
      _saveCounter();
      _showUndoSnackBar();
    }
  }

  void _reset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reiniciar contador'),
        content:
            const Text('¿Estás seguro de que quieres reiniciar el contador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _counter.count = 0;
                _counter.history.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNote(CounterHistoryItem item) async {
    final note = await showDialog<String>(
      context: context,
      builder: (context) => _NoteDialog(initialNote: item.note),
    );

    if (note != null) {
      setState(() {
        item.note = note;
      });
      _saveCounter();
    }
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final service = CounterService(prefs);
    await service.saveCounter(_counter);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _showUndoSnackBar() {
    final localization = context.read<LocalizationService>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localization.translate('round_undone')),
        action: SnackBarAction(
          label: localization.translate('undo'),
          onPressed: _undo,
        ),
      ),
    );
  }

  void _undo() {
    setState(() {
      _counter.count++;
      _counter.history.removeAt(0);
    });
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_counter.name),
        actions: [
          IconButton(
            icon: Icon(_counter.isRunning ? Icons.stop : Icons.play_arrow),
            onPressed: () {
              setState(() {
                if (_counter.isRunning) {
                  _stopTimer();
                } else {
                  _startTimer();
                }
              });
              _saveCounter();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_counter.isRunning) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tiempo vuelta actual: ${_formatDuration(_currentRoundDuration)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
          Expanded(
            flex: 2,
            child: CounterDisplay(count: _counter.count),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CounterButton(
                  icon: Icons.remove,
                  onPressed: _counter.count > 0 ? _decrement : null,
                ),
                CounterButton(
                  icon: Icons.add,
                  onPressed: _increment,
                  primary: true,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: CounterHistory(
              history: _counter.history,
              onAddNote: _addNote,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class _NoteDialog extends StatefulWidget {
  final String? initialNote;

  const _NoteDialog({this.initialNote});

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar nota'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Escribe una nota...'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
