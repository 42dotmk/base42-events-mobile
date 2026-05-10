import 'package:flutter/material.dart';

class DiscardChangesDialog extends StatelessWidget {
  const DiscardChangesDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const DiscardChangesDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Discard changes?'),
      content: const Text(
        'You have unsaved changes. Are you sure you want to leave?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Discard'),
        ),
      ],
    );
  }
}
