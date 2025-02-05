import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pattern.dart';
import '../../services/localization_service.dart';
import 'widgets/pattern_markdown_editor.dart';
import 'widgets/pattern_markdown_preview.dart';
import '../../services/pdf_service.dart';
import 'dart:io';

class PatternDetailScreen extends StatefulWidget {
  final Pattern? pattern;

  const PatternDetailScreen({
    super.key,
    this.pattern,
  });

  @override
  State<PatternDetailScreen> createState() => _PatternDetailScreenState();
}

class _PatternDetailScreenState extends State<PatternDetailScreen> {
  late Pattern _pattern;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _difficulty = 'beginner';
  final List<String> _difficultyLevels = [
    'beginner',
    'intermediate',
    'advanced',
    'expert'
  ];

  @override
  void initState() {
    super.initState();
    _pattern = widget.pattern ??
        Pattern(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '',
          difficulty: 'beginner',
          content: '',
          createdAt: DateTime.now(),
        );
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = _pattern.name;
    _descriptionController.text = _pattern.description;
    _difficulty = _pattern.difficulty;
  }

  void _savePattern() {
    if (_formKey.currentState!.validate()) {
      _pattern.name = _nameController.text;
      _pattern.description = _descriptionController.text;
      _pattern.difficulty = _difficulty;
      _pattern.updatedAt = DateTime.now();
      Navigator.pop(context, _pattern);
    }
  }

  Future<void> _exportToPdf() async {
    try {
      final pdfService = PdfService();
      final filePath = await pdfService.exportPatternToPdf(_pattern);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF guardado en: $filePath'),
          action: SnackBarAction(
            label: 'Abrir',
            onPressed: () async {
              final file = File(filePath);
              if (await file.exists()) {
                // Aquí puedes usar un package como open_file para abrir el PDF
                // await OpenFile.open(filePath);
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final localization = context.read<LocalizationService>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localization.translate('error_exporting_pdf')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.pattern == null
                ? localization.translate('new_pattern')
                : localization.translate('edit_pattern')),
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                tooltip: localization.translate('export'),
                onPressed: _exportToPdf,
              ),
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: localization.translate('save'),
                onPressed: _savePattern,
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: localization.translate('pattern_name_label'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.translate('enter_pattern_name');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: localization.translate('description_label'),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _difficulty,
                  decoration: InputDecoration(
                    labelText: localization.translate('difficulty_label'),
                    border: const OutlineInputBorder(),
                  ),
                  items: _difficultyLevels.map((String difficulty) {
                    return DropdownMenuItem(
                      value: difficulty,
                      child: Text(localization.translate(difficulty)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _difficulty = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.translate('instructions_label'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        PatternMarkdownEditor(
                          initialValue: _pattern.content,
                          onChanged: (value) {
                            setState(() {
                              _pattern.content = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_pattern.content.isNotEmpty)
                  PatternMarkdownPreview(content: _pattern.content),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorSnackbar(BuildContext context, String key) {
    final localization = context.read<LocalizationService>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localization.translate(key)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
