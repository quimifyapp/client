import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';

class UndoButton extends StatelessWidget {
  const UndoButton({
    Key? key,
    required this.width,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  final double width;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: 40,
      width: width,
      enabled: enabled,
      onPressed: onPressed,
      backgroundColor: const Color.fromARGB(255, 255, 96, 96),
      child: Icon(
        Icons.undo,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 22,
      ),
    );
  }
}
