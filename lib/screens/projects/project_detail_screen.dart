import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../models/round.dart';
import 'widgets/round_list_item.dart';
import 'widgets/project_info_card.dart';
import 'widgets/image_carousel.dart';
import '../../services/localization_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project? project;

  const ProjectDetailScreen({super.key, this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Project _project;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hookSizeController = TextEditingController();
  final _yarnTypeController = TextEditingController();
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _project =
        widget.project ??
        Project(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '',
          description: '',
          createdAt: DateTime.now(),
          status: ProjectStatus.notStarted,
          rounds: [],
          images: [],
        );

    _nameController.text = _project.name;
    _descriptionController.text = _project.description;
    _hookSizeController.text = _project.hookSize ?? '';
    _yarnTypeController.text = _project.yarnType ?? '';
    _deadline = _project.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _hookSizeController.dispose();
    _yarnTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _project.images.addAll(images.map((image) => image.path));
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imágenes: $e')),
      );
    }
  }

  void _addRound() {
    setState(() {
      _project.rounds.add(
        Round(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          number: _project.rounds.length + 1,
          instructions: '',
        ),
      );
    });
  }

  void _updateRound(Round round) {
    final index = _project.rounds.indexWhere((r) => r.id == round.id);
    if (index >= 0) {
      setState(() {
        _project.rounds[index] = round;
      });
    }
  }

  void _deleteRound(String roundId) {
    setState(() {
      _project.rounds.removeWhere((round) => round.id == roundId);
      // Actualizar números de rondas
      for (var i = 0; i < _project.rounds.length; i++) {
        _project.rounds[i].number = i + 1;
      }
    });
  }

  Future<void> _selectDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      _project.name = _nameController.text;
      _project.description = _descriptionController.text;
      _project.hookSize = _hookSizeController.text;
      _project.yarnType = _yarnTypeController.text;
      _project.deadline = _deadline;
      _project.updatedAt = DateTime.now();

      Navigator.pop(context, _project);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.project == null
                  ? localization.translate('new_project')
                  : localization.translate('edit_project'),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.save), onPressed: _saveProject),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ImageCarousel(images: _project.images, onAddImage: _pickImages),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: localization.translate('project_name'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.translate('enter_project_name');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: localization.translate('description'),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ProjectInfoCard(
                  hookSizeController: _hookSizeController,
                  yarnTypeController: _yarnTypeController,
                  status: _project.status,
                  onStatusChanged: (status) {
                    setState(() {
                      _project.status = status;
                    });
                  },
                  deadline: _deadline,
                  onDeadlineSelect: _selectDeadline,
                ),
                const SizedBox(height: 16),
                _buildRoundsList(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addRound,
            tooltip: localization.translate('add_round'),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildRoundsList() {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.translate('rounds'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_project.rounds.where((r) => r.isCompleted).length}/${_project.rounds.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._project.rounds.map(
              (round) => RoundListItem(
                round: round,
                onUpdate: _updateRound,
                onDelete: () => _deleteRound(round.id),
              ),
            ),
          ],
        );
      },
    );
  }
}
