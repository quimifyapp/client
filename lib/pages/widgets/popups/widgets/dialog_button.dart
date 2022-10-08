import 'package:cliente/pages/widgets/appearance/quimify_gradient.dart';
import 'package:cliente/pages/widgets/objects/quimify_button.dart';
import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({Key? key, required this.onPressed, required this.text})
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
