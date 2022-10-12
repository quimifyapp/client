import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:flutter/material.dart';

class QuimifyDialogButton extends StatelessWidget {
  const QuimifyDialogButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton.gradient(
      height: 50,
      gradient: quimifyGradient,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 17,
        ),
      ),
    );
  }
}
