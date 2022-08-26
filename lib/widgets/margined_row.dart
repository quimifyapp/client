import 'package:flutter/material.dart';

class MarginedRow extends StatelessWidget {
  const MarginedRow({Key? key, required this.margin, required this.child})
      : super(key: key);

  final double margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    SizedBox margin = SizedBox(width: this.margin);

    return Row(
      children: [
        margin,
        Expanded(child: child),
        margin,
      ],
    );
  }
}
