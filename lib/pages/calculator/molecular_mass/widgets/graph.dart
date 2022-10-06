import 'package:cliente/pages/calculator/molecular_mass/widgets/graph_bar.dart';
import 'package:cliente/pages/calculator/molecular_mass/widgets/graph_quantity.dart';
import 'package:cliente/pages/calculator/molecular_mass/widgets/graph_symbol.dart';
import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  const Graph(
      {Key? key,
        required this.symbols,
        required this.bars,
        required this.quantities})
      : super(key: key);

  final List<GraphSymbol> symbols;
  final List<GraphBar> bars;
  final List<GraphQuantity> quantities;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: symbols
              .map(
                (symbol) => Column(
              children: [
                symbol,
                const SizedBox(height: 15),
              ],
            ),
          )
              .toList(),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            children: bars
                .map(
                  (bar) => Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  children: [
                    bar,
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            )
                .toList(),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: quantities
              .map(
                (amount) => Column(
              children: [
                amount,
                const SizedBox(height: 15),
              ],
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}
