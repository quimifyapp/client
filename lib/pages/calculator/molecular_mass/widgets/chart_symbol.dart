import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class ChartSymbol extends StatelessWidget {
  const ChartSymbol({Key? key, required this.symbol}) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: QuimifyColors.primary(context),
        fontSize: 16,
      ),
    );
  }
}
