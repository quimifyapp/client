import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      required this.color,
      this.gradient,
      required this.onPressed})
      : super(key: key);

  const Button.gradient(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      this.color,
      required this.gradient,
      required this.onPressed})
      : super(key: key);

  final Widget child;
  final double? width, height;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 50,
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox.expand(
        child: MaterialButton(
          padding: const EdgeInsets.all(0),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
