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

class _TutorialOverlayState extends State<TutorialOverlay> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = Colors.black.withOpacity(0.85);
    final targetRect = _getTargetRect();
    final screenSize = MediaQuery.of(context).size;
    final step = widget.steps[currentStep];

    // Determinar la posición de la tarjeta del tutorial
    double cardTop = 100.0;
    if (targetRect != null) {
      cardTop = targetRect.bottom + 20;
      if (cardTop > screenSize.height - 200) {
        cardTop = targetRect.top - 200;
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Fondo oscuro
          Container(
            width: screenSize.width,
            height: screenSize.height,
            color: overlayColor,
          ),

          // Spotlight
          if (targetRect != null)
            Positioned.fill(
              child: CustomPaint(
                painter: SpotlightPainter(
                  targetRect: targetRect,
                  overlayColor: overlayColor,
                ),
              ),
            ),

          // Elemento resaltado
          if (targetRect != null)
            Positioned(
              left: targetRect.left,
              top: targetRect.top,
              width: targetRect.width,
              height: targetRect.height,
              child: _buildHighlightedElement(step),
            ),

          // Tarjeta del tutorial
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 20,
            right: 20,
            top: cardTop,
            child: Card(
              color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
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
                      step.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentStep > 0)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                currentStep--;
                              });
                            },
                            child: Text(
                              context
                                  .read<LocalizationService>()
                                  .translate('previous'),
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            if (currentStep < widget.steps.length - 1) {
                              setState(() {
                                currentStep++;
                              });
                            } else {
                              widget.onComplete();
                            }
                          },
                          child: Text(
                            currentStep < widget.steps.length - 1
                                ? context
                                    .read<LocalizationService>()
                                    .translate('next')
                                : context
                                    .read<LocalizationService>()
                                    .translate('finish'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedElement(TutorialStep step) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (step.targetKey == null) return const SizedBox();

    // Clonar el elemento original
    final RenderBox? renderBox =
        step.targetKey!.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return const SizedBox();

    // Encontrar el widget original
    final Widget? originalWidget =
        (step.targetKey!.currentContext?.widget as Container?)?.child;
    if (originalWidget == null) return const SizedBox();

    // Devolver una copia del widget original
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: originalWidget,
    );
  }

  Rect? _getTargetRect() {
    final step = widget.steps[currentStep];
    if (step.targetKey != null) {
      final RenderBox? renderBox =
          step.targetKey!.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final Offset offset = renderBox.localToGlobal(Offset.zero);
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

// Agregar esta nueva clase para el efecto de spotlight
class SpotlightPainter extends CustomPainter {
  final Rect targetRect;
  final Color overlayColor;

  SpotlightPainter({
    required this.targetRect,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;
    final spotlightPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        targetRect,
        const Radius.circular(16),
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(spotlightPath, paint);
  }

  @override
  bool shouldRepaint(SpotlightPainter oldDelegate) =>
      targetRect != oldDelegate.targetRect ||
      overlayColor != oldDelegate.overlayColor;
}
