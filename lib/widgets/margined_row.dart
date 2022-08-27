import 'package:flutter/material.dart';

class MarginedRow extends StatelessWidget {
  const MarginedRow({Key? key, required this.margin, this.left, this.right,
    required this.child}) : super(key: key);

  const MarginedRow.right({Key? key, this.margin, this.left,
    required this.right, required this.child}) : super(key: key);

  final double? margin;
  final double? left;
  final double? right;

  final Widget child;

  double _marginFor(double? provided) {
    return provided ?? margin ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: _marginFor(left)),
        child,
        SizedBox(width: _marginFor(right)),
      ],
    );
  }
}
