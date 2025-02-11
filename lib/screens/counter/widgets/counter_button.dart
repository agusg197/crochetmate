import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;

  const CounterButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: primary
          ? Theme.of(context).colorScheme.primary
          : isDark
              ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
              : Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 32,
            color: primary || isDark
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
