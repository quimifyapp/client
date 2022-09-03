import 'dart:math';

import 'package:cliente/utils/popups.dart';
import 'package:cliente/widgets/button.dart';
import 'package:cliente/widgets/help_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../utils/text.dart';
import '../../widgets/button.dart';
import '../../widgets/constants.dart';
import '../../widgets/home_app_bar.dart';
import '../../api/results/molecular_mass_result.dart';

class MolecularMassPage extends StatefulWidget {
  const MolecularMassPage({Key? key}) : super(key: key);

  @override
  State<MolecularMassPage> createState() => _MolecularMassPageState();
}

class _MolecularMassPageState extends State<MolecularMassPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // Initial values:

  String _labelText = 'H₂SO₄';
  MolecularMassResult _result = MolecularMassResult(true, 97.96737971,
      {'H': 2.01588, 'S': 32.066, 'O': 63.976}, {'H': 2, 'S': 1, 'O': 4}, '');

  Future<void> _calculate(String input) async {
    if (!isEmptyWithSpaces(input)) {
      String formula = toDigits(input);
      MolecularMassResult? result = await Api().getMolecularMass(formula);

      if (result != null) {
        if (result.present) {
          setState(() => _result = result);

          // UI/UX actions:

          _labelText = input; // Sets previous input as label
          _textController.clear(); // Clears input
          _textFocusNode.unfocus(); // Hides keyboard

          _scrollToEnd(); // Goes to the end of the page
        } else {
          if (!mounted) return; // For security reasons
          showReportDialogPopup(
              context, 'Sin resultado', toSubscripts(result.error));
        }
      } else {
        if (!mounted) return; // For security reasons
        showReportDialogPopup(context, 'Sin resultado');
      }
    }
  }

  void _scrollToEnd() {
    // Goes to the end of the page:
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _scrollToStart() {
    // Goes to the top of the page after a delay:
    Future.delayed(
      const Duration(milliseconds: 200),
      () => WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  void _startTyping() {
    // Like if the TextField was tapped:
    _textFocusNode.requestFocus();
    _scrollToStart();
  }

  void _eraseTextIfEmpty(input) {
    if (isEmptyWithSpaces(input)) {
      _textController.clear(); // Clears input
    }
  }

  void _pressedButton() {
    _calculate(_textController.text);

    if (_textFocusNode.hasFocus) {
      _textFocusNode.unfocus();
    }

    if (isEmptyWithSpaces(_textController.text)) {
      if (!_textFocusNode.hasFocus) {
        _startTyping();
      } else {
        _textController.clear(); // Clears input
      }
    }
  }

  void _submittedText(String input) {
    // Keyboard will be hidden afterwards
    _calculate(input);
    _eraseTextIfEmpty(input);
  }

  void _tapOutsideText() {
    _textFocusNode.unfocus(); // Hides keyboard
    _eraseTextIfEmpty(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tapOutsideText,
      child: Container(
        decoration: quimifyGradientBoxDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // App bar:
              const HomeAppBar(
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
                  // To avoid rounded corners overflow:
                  clipBehavior: Clip.hardEdge,
                  // Vertically scrollable for short devices:
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Like if the TextField was tapped:
                            _startTyping();
                          },
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fórmula',
                                  style: subTitleStyle,
                                ),
                                const Spacer(),
                                TextField(
                                  // Aspect:
                                  cursorColor:
                                      const Color.fromARGB(255, 34, 34, 34),
                                  style: inputOutputStyle,
                                  keyboardType: TextInputType.visiblePassword,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 3),
                                    isCollapsed: true,
                                    labelText: _labelText,
                                    labelStyle: const TextStyle(
                                      color: Colors.black12,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // So hint doesn't go up while typing:
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    // To remove bottom border:
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),
                                  // Logic:
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  scribbleEnabled: false,
                                  focusNode: _textFocusNode,
                                  controller: _textController,
                                  onChanged: (input) {
                                    _textController.value =
                                        _textController.value.copyWith(
                                      text: formatFormula(input),
                                    );
                                  },
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: _submittedText,
                                  onTap: _scrollToStart,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Output(mass: _result.mass),
                        const SizedBox(height: 25),
                        Button.gradient(
                          height: 50,
                          gradient: quimifyGradient,
                          onPressed: _pressedButton,
                          child: const Text(
                            'Calcular',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GraphMenu(
                          mass: _result.mass,
                          elementToGrams: _result.elementToGrams,
                          elementToMoles: _result.elementToMoles,
                        ),
                        // To keep it above navigation bar:
                        const SizedBox(height: 50 + 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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

class Output extends StatelessWidget {
  const Output({Key? key, required this.mass}) : super(key: key);

  final num mass;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Masa molecular',
                style: subTitleStyle,
              ),
              Spacer(),
              HelpButton(),
            ],
          ),
          const Spacer(),
          AutoSizeText(
            '${mass.toStringAsFixed(3)} g/mol',
            stepGranularity: 0.1,
            maxLines: 1,
            style: inputOutputStyle,
          ),
        ],
      ),
    );
  }
}

class GraphMenu extends StatefulWidget {
  const GraphMenu(
      {Key? key,
      required this.mass,
      required this.elementToGrams,
      required this.elementToMoles})
      : super(key: key);

  final num mass;
  final Map<String, num> elementToGrams;
  final Map<String, int> elementToMoles;

  @override
  State<GraphMenu> createState() => _GraphMenuState();
}

class _GraphMenuState extends State<GraphMenu> {
  bool _mol = false;

  @override
  Widget build(BuildContext context) {
    List<GraphSymbol> symbols = [];
    List<GraphBar> gramBars = [];
    List<GraphAmount> gramAmounts = [];

    widget.elementToGrams.forEach((symbol, grams) {
      symbols.add(GraphSymbol(symbol: symbol));
      gramBars.add(GraphBar(amount: grams, total: widget.mass));
      gramAmounts.add(GraphAmount(amount: '${grams.round()} g'));
    });

    String formula = '';
    List<GraphBar> molBars = [];
    List<GraphAmount> molAmounts = [];

    int totalMoles = widget.elementToMoles.values.reduce((sum, i) => sum + i);
    widget.elementToMoles.forEach((symbol, moles) {
      formula += moles > 1 ? '$symbol$moles' : symbol;
      molBars.add(GraphBar(amount: moles, total: totalMoles));
      molAmounts.add(GraphAmount(amount: '$moles mol'));
    });

    return Container(
      decoration: BoxDecoration(
        color: quimifyTeal.withOpacity(0.08),
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
                  overflowReplacement: const Text(
                    'Proporciones',
                    maxLines: 1,
                    style: TextStyle(
                      color: quimifyTeal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  stepGranularity: 0.1,
                  maxLines: 1,
                  style: const TextStyle(
                    color: quimifyTeal,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                activeColor: Colors.white,
                activeTrackColor: quimifyTeal,
                inactiveTrackColor: Colors.black12,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: _mol,
                onChanged: (bool value) {
                  setState(() {
                    _mol = value;
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
          const SizedBox(height: 15),
          IndexedStack(
            index: _mol ? 1 : 0,
            children: [
              Graph(symbols: symbols, bars: gramBars, amounts: gramAmounts),
              Graph(symbols: symbols, bars: molBars, amounts: molAmounts),
            ],
          ),
        ],
      ),
    );
  }
}

class Graph extends StatelessWidget {
  const Graph(
      {Key? key,
      required this.symbols,
      required this.bars,
      required this.amounts})
      : super(key: key);

  final List<GraphSymbol> symbols;
  final List<GraphBar> bars;
  final List<GraphAmount> amounts;

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
          children: amounts
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

class GraphSymbol extends StatelessWidget {
  const GraphSymbol({Key? key, required this.symbol}) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol,
      textAlign: TextAlign.left,
      style: const TextStyle(
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
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      child: FractionallySizedBox(
        widthFactor: min(proportion, 1),
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
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}
