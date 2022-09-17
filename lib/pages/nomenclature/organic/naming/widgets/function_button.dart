import 'package:flutter/material.dart';

class FunctionButton extends StatelessWidget {
  const FunctionButton(
      {Key? key,
      required this.bonds,
      required this.text,
      required this.onPressed})
      : super(key: key);

  final int bonds;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed,
      child: Text('$bonds $text'),
    );
  }
}
