import 'package:flutter/material.dart';

class SquareIconButton extends StatelessWidget {
  const SquareIconButton(
      {Key? key,
      required this.iconData,
      required this.color,
      required this.backgroundColor,
      required this.onPressed})
      : super(key: key);

  final IconData iconData;
  final Color color, backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox.expand(
        child: MaterialButton(
          padding: const EdgeInsets.all(0),
          onPressed: onPressed,
          child: Icon(
            iconData,
            color: color,
          ),
        ),
      ),
    );
  }
}
