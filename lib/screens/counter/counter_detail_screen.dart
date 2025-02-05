import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/counter.dart';
import '../../services/localization_service.dart';

class CounterDetailScreen extends StatefulWidget {
  final Counter? counter;

  const CounterDetailScreen({super.key, this.counter});

  @override
  State<CounterDetailScreen> createState() => _CounterDetailScreenState();
}

class _CounterDetailScreenState extends State<CounterDetailScreen> {
  final _nameController = TextEditingController();
  late Counter _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.counter ?? Counter(id: '', name: '', count: 0);
    _nameController.text = _counter.name;
  }

  void _saveCounter() {
    if (_nameController.text.isNotEmpty) {
      _counter.name = _nameController.text;
      Navigator.pop(context, _counter);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.counter == null
                ? localization.translate('new_counter')
                : localization.translate('edit_counter')),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: localization.translate('save'),
                onPressed: _saveCounter,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: localization.translate('counter_name'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.translate('enter_counter_name');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  localization.translate('current_count'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // ... resto del código
              ],
            ),
          ),
        );
      },
    );
  }
}
