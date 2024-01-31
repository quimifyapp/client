import 'package:flutter/material.dart';

class DialogContentText extends StatelessWidget {
  const DialogContentText({
    Key? key,
    required this.text,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  final String text;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
        fontWeight: fontWeight,
      ),
      strutStyle: const StrutStyle(height: 1.5),
    );
  }
}
