import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton.gradient(
      height: 50,
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
