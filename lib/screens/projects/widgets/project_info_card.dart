import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/project.dart';
import '../../../services/localization_service.dart';

class ProjectInfoCard extends StatelessWidget {
  final TextEditingController hookSizeController;
  final TextEditingController yarnTypeController;
  final ProjectStatus status;
  final Function(ProjectStatus) onStatusChanged;
  final DateTime? deadline;
  final VoidCallback onDeadlineSelect;

  const ProjectInfoCard({
    super.key,
    required this.hookSizeController,
    required this.yarnTypeController,
    required this.status,
    required this.onStatusChanged,
    required this.deadline,
    required this.onDeadlineSelect,
  });

  @override
  Widget build(BuildContext context) {
    final localization = context.read<LocalizationService>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.translate('project_details'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
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
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: status.color, size: 16),
                      const SizedBox(width: 8),
                      Text(status.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) onStatusChanged(value);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(localization.translate('deadline_title')),
              subtitle: Text(
                deadline != null
                    ? '${deadline!.day}/${deadline!.month}/${deadline!.year}'
                    : localization.translate('no_deadline'),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: onDeadlineSelect,
            ),
          ],
        ),
      ),
    );
  }
}
