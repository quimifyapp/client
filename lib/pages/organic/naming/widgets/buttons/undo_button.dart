import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';

class UndoButton extends StatelessWidget {
  const UndoButton({
    Key? key,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: 40,
      backgroundColor: const Color.fromARGB(255, 255, 96, 96),
      enabled: enabled,
      onPressed: onPressed,
      child: Icon(
        Icons.undo,
        size: 22,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
