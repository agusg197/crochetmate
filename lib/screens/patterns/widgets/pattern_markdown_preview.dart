import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PatternMarkdownPreview extends StatelessWidget {
  final String content;

  const PatternMarkdownPreview({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Vista Previa',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              data: content,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                h1: Theme.of(context).textTheme.headlineMedium,
                h2: Theme.of(context).textTheme.titleLarge,
                p: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
