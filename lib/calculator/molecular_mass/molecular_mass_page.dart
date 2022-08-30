import 'package:flutter/material.dart';

import '../../utils/text.dart';
import '../../widgets/constants.dart';
import '../../widgets/home_app_bar.dart';
import 'molecular_mass_result.dart';

class MolecularMassPage extends StatefulWidget {
  MolecularMassPage({Key? key}) : super(key: key);

  @override
  State<MolecularMassPage> createState() => _MolecularMassPageState();
}

class _MolecularMassPageState extends State<MolecularMassPage> {
  String _input = 'H₂SO₄';
  bool _mol = false;

  MolecularMassResult _result = MolecularMassResult();

  List<GraphSymbol> _symbols = [];
  List<GraphBar> _gramBars = [], _molBars = [];
  List<GraphAmount> _gramAmounts = [], _molAmounts = [];

  @override
  Widget build(BuildContext context) {
    _symbols = [];

    _gramBars = [];
    _gramAmounts = [];
    _result.elementToGrams.forEach((symbol, grams) {
      _symbols.add(GraphSymbol(symbol: symbol));

      _gramBars.add(GraphBar(amount: grams, total: _result.mass));

      int rounded_grams = grams.round();
      _gramAmounts.add(GraphAmount(amount: '$rounded_grams g'));
    });

    _molBars = [];
    _molAmounts = [];
    _result.elementToMoles.forEach((symbol, moles) {
      _molBars.add(GraphBar(amount: moles, total: _result.moles));

      _molAmounts.add(GraphAmount(amount: '$moles mol'));
    });

    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // App bar:
            HomeAppBar(
              title: Text(
                'Calculadora',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Body:
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                width: double.infinity,
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                // Vertically scrollable for short devices:
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: Column(
                    children: [
                      Input(),
                      SizedBox(height: 20),
                      Output(mass: _result.mass.toStringAsFixed(3)),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: quimifyGradient,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Calcular',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        decoration: BoxDecoration(
                          color: quimifyTeal.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  _result.formula,
                                  style: TextStyle(
                                    color: quimifyTeal,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Switch(
                                  activeColor: Colors.white,
                                  activeTrackColor: quimifyTeal,
                                  inactiveTrackColor: Colors.black12,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: _mol,
                                  onChanged: (bool) {
                                    setState(() {
                                      _mol = !_mol;
                                    });
                                  },
                                ),
                                Text(
                                  'Pasar a mol',
                                  style: TextStyle(
                                    color: _mol ? quimifyTeal : Colors.black12,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            IndexedStack(
                              index: _mol ? 1 : 0,
                              children: [
                                Graph(
                                    symbols: _symbols,
                                    bars: _gramBars,
                                    amounts: _gramAmounts),
                                Graph(
                                    symbols: _symbols,
                                    bars: _molBars,
                                    amounts: _molAmounts),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // To keep it above navigation bar:
                      SizedBox(height: 50 + 60 + 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const TextStyle subTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

const TextStyle inputOutputStyle = TextStyle(
  color: quimifyTeal,
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

class Input extends StatefulWidget {
  Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fórmula:',
            style: subTitleStyle,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: TextField(
              // Aspect:
              cursorColor: Color.fromARGB(255, 34, 34, 34),
              style: inputOutputStyle,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 10),
                isCollapsed: true,
                //filled: false,
                labelText: 'H₂SO₄',
                labelStyle: inputOutputStyle,
                // So hint doesn't go up while typing:
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: quimifyTeal.withOpacity(0.5)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: quimifyTeal.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: quimifyTeal),
                ),
              ),
              // Logic:
              textInputAction: TextInputAction.done,
              controller: _controller,
              onChanged: (String input) {
                _controller.value = _controller.value.copyWith(
                  text: toSubscripts(toCapsAfterDigit(toFirstCap(input))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Output extends StatelessWidget {
  const Output({Key? key, required this.mass}) : super(key: key);

  final String mass;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masa molecular:',
            style: subTitleStyle,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              mass + ' g/mol',
              style: inputOutputStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class GraphSymbol extends StatelessWidget {
  const GraphSymbol({Key? key, required this.symbol}) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}

class GraphBar extends StatelessWidget {
  const GraphBar({Key? key, required this.amount, required this.total})
      : super(key: key);

  final num amount, total;

  @override
  Widget build(BuildContext context) {
    double proportion = amount / total;

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: proportion < 1 ? proportion : 1,
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            color: quimifyTeal,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class GraphAmount extends StatelessWidget {
  const GraphAmount({Key? key, required this.amount}) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text(
      amount,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}

class Graph extends StatelessWidget {
  Graph(
      {Key? key,
      required this.symbols,
      required this.bars,
      required this.amounts})
      : super(key: key);

  List<GraphSymbol> symbols = [];
  List<GraphBar> bars = [];
  List<GraphAmount> amounts = [];

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
                    SizedBox(height: 15),
                  ],
                ),
              )
              .toList(),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            children: bars
                .map(
                  (bar) => Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      children: [
                        bar,
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: amounts
              .map(
                (amount) => Column(
                  children: [
                    amount,
                    SizedBox(height: 15),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
