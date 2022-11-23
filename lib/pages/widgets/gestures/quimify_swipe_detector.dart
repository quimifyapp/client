import 'package:flutter/material.dart';

class QuimifySwipeDetector extends StatelessWidget {
  const QuimifySwipeDetector({
    Key? key,
    required this.leftSwipe,
    required this.rightSwipe,
    required this.child,
  }) : super(key: key);

  final VoidCallback leftSwipe, rightSwipe;
  final Widget child;

  static const int _swipeSensibility = 500;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
        double horizontalSpeed = dragEndDetails.velocity.pixelsPerSecond.dx;
        if (horizontalSpeed > _swipeSensibility) {
          leftSwipe();
        } else if (horizontalSpeed < -_swipeSensibility) {
          rightSwipe();
        }
      },
      child: child,
    );
  }
}
