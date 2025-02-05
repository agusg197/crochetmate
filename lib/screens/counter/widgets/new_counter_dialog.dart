import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/localization_service.dart';

class NewCounterDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  NewCounterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.read<LocalizationService>();

    return AlertDialog(
      title: Text(localization.translate('new_counter_dialog_title')),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: localization.translate('counter_name'),
          hintText: localization.translate('counter_name_hint'),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localization.translate('cancel')),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: Text(localization.translate('create')),
        ),
      ],
    );
  }
}
