import 'package:flutter/material.dart';

class DialogContent extends StatelessWidget {
  const DialogContent({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
      ),
      strutStyle: const StrutStyle(height: 1.5),
    );
  }
}
