import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';

class QuimifyButton extends StatelessWidget {
  const QuimifyButton({
    super.key,
    this.width,
    required this.height,
    required this.color,
    this.enabled = true,
    required this.onPressed,
    required this.child,
  }) : gradient = false;

  const QuimifyButton.gradient({
    super.key,
    this.width,
    required this.height,
    this.enabled = true,
    required this.onPressed,
    required this.child,
  })  : color = null,
        gradient = true;

  final Widget child;
  final double? width;
  final double height;
  final Color? color;
  final bool enabled;
  final bool gradient;
  final VoidCallback onPressed;

  static const double _unselectedOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    double opacity = enabled ? 1 : _unselectedOpacity;

    return Container(
      width: width,
      height: height,
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: gradient ? quimifyGradient(opacity: opacity) : null,
        color: color?.withOpacity(opacity),
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
