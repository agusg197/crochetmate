import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'services/localization_service.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/language_provider.dart';
import 'services/hive_service.dart';
import 'utils/icon_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await generateIcon();
  await HiveService.initialize();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalizationService(prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(
            context.read<LocalizationService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(prefs),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              title: localization.translate('app_title'),
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              home: const HomeScreen(),
              initialRoute: '/splash',
              routes: {
                '/splash': (context) => const SplashScreen(),
                '/home': (context) => const HomeScreen(),
              },
              key: ValueKey('app_${localization.currentLanguage}'),
            );
          },
        );
      },
    );
  }
}
