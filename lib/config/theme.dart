import 'package:flutter/material.dart';

class AppTheme extends StatefulWidget {
  const AppTheme({super.key});

  // Colores personalizados estáticos
  static const Color primaryColor = Color(0xFF7E57C2);
  static const Color secondaryColor = Color(0xFFFF80AB);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF424242);

  // Mover los temas aquí como propiedades estáticas
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5CF6), // Un morado más moderno
      secondary: const Color(0xFFEC4899), // Rosa más vibrante
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),

    // AppBar tema
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Botón flotante tema
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Texto tema
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      onSurface: Colors.white.withOpacity(0.87),
      onBackground: Colors.white.withOpacity(0.87),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: const Color(0xFF2D2D2D),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.87)),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.87),
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.87),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.87),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.87),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white.withOpacity(0.87),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white.withOpacity(0.87),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.6),
      ),
    ),
  );

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _animations = List.generate(
      4,
      (index) => CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          0.6 + index * 0.1,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aquí debes implementar el método build
    return Container(); // Reemplaza esto con tu widget real
  }

  Widget _buildAnimatedCard(
    int index,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final colors = [
      const Color(0xFFE8D5FF), // Lila suave
      const Color(0xFFFFE8F0), // Rosa suave
      const Color(0xFFD5F0FF), // Azul suave
      const Color(0xFFE8FFE8), // Verde suave
    ];

    final iconColors = [
      const Color(0xFF9B6DFF), // Lila fuerte
      const Color(0xFFFF6B9B), // Rosa fuerte
      const Color(0xFF6BB5FF), // Azul fuerte
      const Color(0xFF6BCD6B), // Verde fuerte
    ];

    return ScaleTransition(
      scale: _animations[index],
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : colors[index],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[index].withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? iconColors[index].withOpacity(0.2)
                          : iconColors[index].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? iconColors[index].withOpacity(0.8)
                          : iconColors[index],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : iconColors[index].withOpacity(0.8),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  _buildSubtitle(index),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(int index) {
    final subtitles = [
      'Gestiona tus proyectos',
      'Explora patrones',
      'Cuenta vueltas',
      'Personaliza la app',
    ];

    return Text(
      subtitles[index],
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black54,
          ),
      textAlign: TextAlign.center,
    );
  }

  void _checkAndShowTutorial() {
    // Implementa la lógica para verificar si se debe mostrar el tutorial
  }
}
