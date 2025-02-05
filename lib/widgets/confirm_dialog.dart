import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

Future<bool?> showConfirmDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    builder: (context) => Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return AlertDialog(
          title: Text(localization.translate('confirm')),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(localization.translate('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(localization.translate('confirm')),
            ),
          ],
        );
      },
    ),
  );
}
