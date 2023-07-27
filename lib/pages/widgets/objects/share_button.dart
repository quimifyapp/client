import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
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
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      icon: Icon(
        Icons.share_outlined,
        color: Theme.of(context).colorScheme.onErrorContainer,
        size: 18,
      ),
    );
  }
}
