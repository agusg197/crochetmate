import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, _) {
        return TextButton(
          onPressed: () async {
            final newLanguage = provider.currentLanguage == 'es' ? 'en' : 'es';
            await provider.changeLanguage(newLanguage);

            if (context.mounted) {
              // Forzar la reconstrucción del árbol de widgets
              await Future.delayed(const Duration(milliseconds: 100));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      provider.translate(newLanguage == 'es'
                          ? 'language_changed_es'
                          : 'language_changed_en'),
                    ),
                  ),
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              provider.currentLanguage.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
