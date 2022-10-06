import 'package:flutter/material.dart';

class GraphQuantity extends StatelessWidget {
  const GraphQuantity({Key? key, required this.quantity}) : super(key: key);

  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Text(
      quantity,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
      ),
    );
  }
}
