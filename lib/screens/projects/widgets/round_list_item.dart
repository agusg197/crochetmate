import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/round.dart';
import '../../../services/localization_service.dart';

class RoundListItem extends StatefulWidget {
  final Round round;
  final Function(Round) onUpdate;
  final VoidCallback onDelete;

  const RoundListItem({
    super.key,
    required this.round,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<RoundListItem> createState() => _RoundListItemState();
}

class _RoundListItemState extends State<RoundListItem> {
  late TextEditingController _instructionsController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _instructionsController =
        TextEditingController(text: widget.round.instructions);
    _notesController = TextEditingController(text: widget.round.notes);
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateRound() {
    final updatedRound = Round(
      id: widget.round.id,
      number: widget.round.number,
      instructions: _instructionsController.text,
      isCompleted: widget.round.isCompleted,
      stitchCount: widget.round.stitchCount,
      notes: _notesController.text,
    );
    widget.onUpdate(updatedRound);
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.read<LocalizationService>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title:
            Text('${localization.translate('round')} ${widget.round.number}'),
        subtitle: Text(
          widget.round.instructions.isEmpty
              ? localization.translate('no_instructions')
              : widget.round.instructions,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Checkbox(
          value: widget.round.isCompleted,
          onChanged: (value) {
            if (value != null) {
              final updatedRound = Round(
                id: widget.round.id,
                number: widget.round.number,
                instructions: widget.round.instructions,
                isCompleted: value,
                stitchCount: widget.round.stitchCount,
                notes: widget.round.notes,
              );
              widget.onUpdate(updatedRound);
            }
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: widget.onDelete,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _instructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Instrucciones',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (_) => _updateRound(),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (_) => _updateRound(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
