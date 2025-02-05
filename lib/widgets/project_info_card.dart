import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/localization_service.dart';
import 'package:provider/provider.dart';

class ProjectInfoCard extends StatelessWidget {
  final TextEditingController hookSizeController;
  final TextEditingController yarnTypeController;
  final ProjectStatus status;
  final ValueChanged<ProjectStatus?> onStatusChanged;
  final DateTime? deadline;
  final VoidCallback onDeadlineSelect;

  const ProjectInfoCard({
    super.key,
    required this.hookSizeController,
    required this.yarnTypeController,
    required this.status,
    required this.onStatusChanged,
    this.deadline,
    required this.onDeadlineSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: hookSizeController,
                  decoration: InputDecoration(
                    labelText: localization.translate('hook_size'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: yarnTypeController,
                  decoration: InputDecoration(
                    labelText: localization.translate('yarn_type'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ProjectStatus>(
                  value: status,
                  decoration: InputDecoration(
                    labelText: localization.translate('status'),
                    border: const OutlineInputBorder(),
                  ),
                  items: ProjectStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(localization
                          .translate(status.toString().toLowerCase())),
                    );
                  }).toList(),
                  onChanged: onStatusChanged,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
