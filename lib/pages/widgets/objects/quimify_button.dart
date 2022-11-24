import 'package:flutter/material.dart';

class QuimifyButton extends StatelessWidget {
  const QuimifyButton({
    Key? key,
    this.width,
    required this.height,
    required this.backgroundColor,
    this.gradient,
    this.enabled = true,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  const QuimifyButton.gradient({
    Key? key,
    this.width,
    required this.height,
    this.backgroundColor,
    required this.gradient,
    this.enabled = true,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double height;
  final Color? backgroundColor;
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
        borderRadius: BorderRadius.circular(10),
        gradient: gradient,
        color: backgroundColor?.withOpacity(enabled ? 1 : _unselectedOpacity),
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
                onPressed: onPressed,
                child: child,
              ),
      ),
    );
  }
}
