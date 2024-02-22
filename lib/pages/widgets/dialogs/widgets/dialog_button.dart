import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

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
          color: QuimifyColors.inverseText(context),
          fontSize: 17,
        ),
      ),
    );
  }
}
