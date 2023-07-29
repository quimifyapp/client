import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    Key? key,
    this.width,
    required this.height,
    this.iconSize = 24,
    required this.onPressed,
  }) : super(key: key);

  final double? width;
  final double height;
  final double iconSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyIconButton.square(
      height: height,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onPressed: onPressed,
      icon: Icon(
        Icons.history,
        color: Theme.of(context).colorScheme.primary,
        size: iconSize,
      ),
    );
  }
}