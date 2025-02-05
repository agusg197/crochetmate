import 'package:flutter/material.dart';

class PatternMarkdownEditor extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const PatternMarkdownEditor({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<PatternMarkdownEditor> createState() => _PatternMarkdownEditorState();
}

class _PatternMarkdownEditorState extends State<PatternMarkdownEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  void _insertFormat(String format) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$format${text.substring(selection.start, selection.end)}$format',
    );
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + format.length,
      ),
    );
    widget.onChanged(newText);
  }

  void _insertLine(String prefix) {
    final text = _controller.text;
    final selection = _controller.selection;
    final beforeCursor = text.substring(0, selection.start);
    final afterCursor = text.substring(selection.end);
    final newLine = beforeCursor.endsWith('\n') ? '' : '\n';
    final newText = '$beforeCursor$newLine$prefix$afterCursor';

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + newLine.length + prefix.length,
      ),
    );
    widget.onChanged(newText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFormatButton('T1', () => _insertLine('# ')),
              _buildFormatButton('T2', () => _insertLine('## ')),
              _buildFormatButton('B', () => _insertFormat('**')),
              _buildFormatButton('I', () => _insertFormat('_')),
              _buildFormatButton('•', () => _insertLine('- ')),
              _buildFormatButton('1.', () => _insertLine('1. ')),
              _buildFormatButton('[]', () => _insertLine('- [ ] ')),
              _buildFormatButton('Código', () => _insertFormat('`')),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Escribe las instrucciones del patrón aquí...',
            border: OutlineInputBorder(),
          ),
          maxLines: 10,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }

  Widget _buildFormatButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(40, 40),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
