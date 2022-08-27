import 'package:flutter/material.dart';

class MarginedColumn extends StatelessWidget {
  const MarginedColumn({Key? key, this.margin, required this.top,
    required this.bottom, required this.child}) : super(key: key);
  
  const MarginedColumn.center({Key? key, required this.margin, this.top,
    this.bottom, required this.child}) : super(key: key);

  const MarginedColumn.bottom({Key? key, this.margin, this.top,
    required this.bottom, required this.child}) : super(key: key);

  const MarginedColumn.top({Key? key, this.margin, required this.top,
    this.bottom, required this.child}) : super(key: key);

  final double? margin;
  final double? top;
  final double? bottom;

  final Widget child;

  double _marginFor(double? provided) {
    return provided ?? margin ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: _marginFor(top)),
        child,
        SizedBox(height: _marginFor(bottom)),
      ],
    );
  }
}
