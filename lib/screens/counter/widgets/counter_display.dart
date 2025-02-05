import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int count;

  const CounterDisplay({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Vueltas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
