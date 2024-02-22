import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/chart.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/chart_bar.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/chart_number.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/chart_symbol.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_switch.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/text.dart';

class ChartSelector extends StatefulWidget {
  const ChartSelector({
    Key? key,
    required this.mass,
    required this.elementToGrams,
    required this.elementToMoles,
  }) : super(key: key);

  final num mass;
  final Map<String, num> elementToGrams;
  final Map<String, int> elementToMoles;

  @override
  State<ChartSelector> createState() => _ChartSelectorState();
}

class _ChartSelectorState extends State<ChartSelector> {
  bool _molesChart = false;

  _tappedChart() => setState(() => _molesChart = !_molesChart);

  _pressedSwitch(bool newValue) => setState(() => _molesChart = newValue);

  @override
  Widget build(BuildContext context) {
    List<ChartSymbol> symbols = [];

    List<ChartBar> gramBars = [];
    List<ChartNumber> gramQuantities = [];

    widget.elementToGrams.forEach((symbol, grams) {
      symbols.add(ChartSymbol(symbol: symbol));
      gramBars.add(ChartBar(quantity: grams, total: widget.mass));
      gramQuantities.add(ChartNumber(text: '${formatMolecularMass(grams)} g'));
    });

    String formula = '';

    List<ChartBar> molBars = [];
    List<ChartNumber> molQuantities = [];

    int totalMoles = widget.elementToMoles.values.reduce((sum, i) => sum + i);
    widget.elementToMoles.forEach((symbol, moles) {
      formula += moles > 1 ? '$symbol$moles' : symbol;
      molBars.add(ChartBar(quantity: moles, total: totalMoles));
      molQuantities.add(ChartNumber(text: '$moles mol'));
    });

    return GestureDetector(
      onTap: _tappedChart,
      child: Container(
        decoration: BoxDecoration(
          color: QuimifyColors.chartBackground(context),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    toSubscripts(formula),
                    minFontSize: 18,
                    overflowReplacement: Text(
                      'Proporciones',
                      maxLines: 1,
                      style: TextStyle(
                        color: QuimifyColors.teal(),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    stepGranularity: 0.1,
                    maxLines: 1,
                    style: TextStyle(
                      color: QuimifyColors.teal(),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                QuimifySwitch(
                  value: _molesChart,
                  onChanged: _pressedSwitch,
                ),
                Text(
                  'Pasar a mol',
                  style: TextStyle(
                    color: _molesChart
                        ? QuimifyColors.teal()
                        : QuimifyColors.tertiary(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            IndexedStack(
              index: _molesChart ? 1 : 0,
              children: [
                Chart(
                  symbols: symbols,
                  bars: gramBars,
                  quantities: gramQuantities,
                ),
                Chart(
                  symbols: symbols,
                  bars: molBars,
                  quantities: molQuantities,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
