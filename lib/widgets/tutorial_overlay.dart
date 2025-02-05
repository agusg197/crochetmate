import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/localization_service.dart';

class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;

  const TutorialOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 3.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Rect? _getTargetRect() {
    final step = widget.steps[currentStep];
    if (step.targetKey != null) {
      final RenderBox? renderBox =
          step.targetKey!.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        // Usar las dimensiones exactas sin ajustes
        return Rect.fromLTWH(
          offset.dx,
          offset.dy,
          renderBox.size.width,
          renderBox.size.height,
        );
      }
    }
    return step.highlightArea;
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.read<LocalizationService>();
    final targetRect = _getTargetRect();
    final screenSize = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    double cardTop = 100.0;
    if (targetRect != null) {
      if (targetRect.top > screenSize.height / 2) {
        cardTop = targetRect.top - 200;
      } else {
        cardTop = targetRect.bottom + 50;
      }
    }

    Widget buildSpotlightContent() {
      final step = widget.steps[currentStep];
      if (step.title.contains('Projects')) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 48,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 12),
            Text(
              localization.translate('projects'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      } else if (step.title.contains('Counters')) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 48,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 12),
            Text(
              localization.translate('counters'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      } else if (step.title.contains('Patterns')) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grid_view,
              size: 48,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 12),
            Text(
              localization.translate('patterns'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      }
      return const SizedBox();
    }

    return Stack(
      children: [
        // Fondo negro sólido
        Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.black,
        ),

        // Copia del Card para el spotlight
        if (targetRect != null)
          Positioned(
            left: targetRect.left,
            top: targetRect.top,
            width: targetRect.width,
            height: targetRect.height,
            child: Card(
              elevation: 8,
              color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: buildSpotlightContent(),
              ),
            ),
          ),

        // Tarjeta del tutorial
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          left: 24,
          right: 24,
          top: cardTop,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.steps[currentStep].title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.steps[currentStep].description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentStep > 0)
                        TextButton.icon(
                          onPressed: () => setState(() => currentStep--),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(localization.translate('previous')),
                        ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          if (currentStep < widget.steps.length - 1) {
                            setState(() => currentStep++);
                          } else {
                            widget.onComplete();
                          }
                        },
                        icon: Text(
                          currentStep < widget.steps.length - 1
                              ? localization.translate('next')
                              : localization.translate('finish'),
                        ),
                        label: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InverseClipper extends CustomClipper<Path> {
  final Rect rect;

  InverseClipper({required this.rect});

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TutorialStep {
  final String title;
  final String description;
  final Rect? highlightArea;
  final GlobalKey? targetKey;

  TutorialStep({
    required this.title,
    required this.description,
    this.highlightArea,
    this.targetKey,
  });
}
