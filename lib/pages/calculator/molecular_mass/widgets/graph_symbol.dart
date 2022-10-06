import 'package:flutter/material.dart';

class GraphSymbol extends StatelessWidget {
  const GraphSymbol({Key? key, required this.symbol}) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
      ),
    );
  }
}
