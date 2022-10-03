import 'package:flutter/material.dart';

class QuimifyButton extends StatelessWidget {
  const QuimifyButton(
      {Key? key,
      required this.child,
      this.width,
      this.height = 50,
      required this.color,
      this.gradient,
      this.enabled = true,
      required this.onPressed})
      : super(key: key);

  const QuimifyButton.gradient(
      {Key? key,
      required this.child,
      this.width,
      this.height = 50,
      this.color,
      required this.gradient,
      this.enabled = true,
      required this.onPressed})
      : super(key: key);

  final Widget child;
  final double? width;
  final double height;
  final Color? color;
  final Gradient? gradient;
  final bool enabled;
  final VoidCallback onPressed;

  static const double _unselectedOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color?.withOpacity(enabled ? 1 : _unselectedOpacity),
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox.expand(
        child: enabled
            ? MaterialButton(
                padding: const EdgeInsets.all(0),
                splashColor: Colors.transparent,
                onPressed: onPressed,
                child: child,
              )
            : MaterialButton(
                padding: const EdgeInsets.all(0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {},
                child: child,
              ),
      ),
    );
  }
}
