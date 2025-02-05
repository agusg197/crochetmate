import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/language_provider.dart';
import '../../services/localization_service.dart';
import '../../services/tutorial_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localization.translate('settings')),
          ),
          body: ListView(
            children: [
              Consumer2<ThemeProvider, LocalizationService>(
                builder: (context, themeProvider, localization, _) {
                  return ListTile(
                    leading: const Icon(Icons.palette),
                    title: Text(localization.translate('theme')),
                    subtitle: Text(
                      themeProvider.themeMode == ThemeMode.system
                          ? localization.translate('system')
                          : themeProvider.themeMode == ThemeMode.light
                              ? localization.translate('light')
                              : localization.translate('dark'),
                    ),
                    onTap: () =>
                        _showThemeDialog(context, themeProvider, localization),
                  );
                },
              ),
              Consumer2<LanguageProvider, LocalizationService>(
                builder: (context, languageProvider, localization, _) {
                  return ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(localization.translate('language')),
                    subtitle: Text(
                      languageProvider.currentLanguage == 'es'
                          ? localization.translate('language_es')
                          : localization.translate('language_en'),
                    ),
                    onTap: () => _showLanguageDialog(context),
                  );
                },
              ),
              const Divider(),
              Consumer<LocalizationService>(
                builder: (context, localization, _) {
                  return ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: Text(localization.translate('show_tutorial')),
                    subtitle:
                        Text(localization.translate('show_tutorial_desc')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final tutorialService = TutorialService(prefs);
                      await tutorialService.resetTutorial();

                      if (!mounted) return;

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider,
      LocalizationService localization) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localization.translate('select_theme')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(localization.translate('system')),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(localization.translate('light')),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(localization.translate('dark')),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    final localization = context.read<LocalizationService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localization.translate('select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(localization.translate('language_es')),
              onTap: () async {
                await languageProvider.changeLanguage('es');
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        languageProvider.translate('language_changed_es'),
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              title: Text(localization.translate('language_en')),
              onTap: () async {
                await languageProvider.changeLanguage('en');
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        languageProvider.translate('language_changed_en'),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
