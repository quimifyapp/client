import 'package:flutter/material.dart';

import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';

class QuimifyHistoryButton extends StatelessWidget {
  const QuimifyHistoryButton({
    Key? key,
    required this.height,
    required this.onPressed,
  }) : super(key: key);

  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyIconButton.square(
      height: height,
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.surface, // TODO reconsider
      icon: Icon(
        Icons.history,
        color: Theme.of(context).colorScheme.primary, // TODO reconsider
        size: 24,
      ),
    );
  }
}
