import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? splashColor;
  final Color? highlightColor;

  const CustomInkWell({
    required this.child,
    required this.onTap,
    this.splashColor,
    this.highlightColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: splashColor ??
                  Theme.of(context).primaryColor.withOpacity(0.1),
              highlightColor: highlightColor ??
                  Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
