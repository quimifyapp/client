import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

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
    const double borderRadius = 10;
    double opacity = enabled ? 1 : _unselectedOpacity;

    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      // To prevent rounded corners overflow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ? QuimifyColors.gradient(opacity: opacity) : null,
        color: color?.withOpacity(opacity),
      ),
      child: SizedBox.expand(
        child: MaterialButton(
          padding: const EdgeInsets.all(0),
          splashColor: Colors.transparent,
          highlightColor: enabled ? null : Colors.transparent,
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
