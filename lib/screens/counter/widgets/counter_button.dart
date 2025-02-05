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
    return Material(
      color: primary
          ? Theme.of(context).primaryColor
          : Theme.of(context).cardColor,
      elevation: 4,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 40,
            color: primary ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
