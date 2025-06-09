import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final String sentiment;
  final List<String> tags;
  final VoidCallback? onDelete;

  const NoteTile({
    super.key,
    required this.text,
    required this.sentiment,
    required this.tags,
    this.onDelete,
  });

  Color _getNoteColor() {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Colors.green[800]!;
      case 'negative':
        return Colors.red[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getNoteColor(),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        subtitle: Wrap(
          spacing: 6,
          children: tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: Colors.teal,
              labelStyle: const TextStyle(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            );
          }).toList(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
