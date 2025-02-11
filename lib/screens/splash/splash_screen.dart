import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/localization_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  String _quote = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) => _showQuote());
  }

  void _showQuote() {
    final localization = context.read<LocalizationService>();
    final quotes = localization.translate('loading_quotes') as List;
    setState(() {
      _quote = quotes[Random().nextInt(quotes.length)].toString();
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF2C1F46), const Color(0xFF1A1A1A)]
                : [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Icon(
                        Icons.gesture,
                        size: 100,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              AnimatedOpacity(
                opacity: _quote.isEmpty ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _quote,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
