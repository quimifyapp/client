import 'dart:math';

import 'package:cliente/widgets/button.dart';
import 'package:cliente/widgets/dialog_popup.dart';
import 'package:cliente/widgets/help_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../api/api.dart';
import '../../../api/results/molecular_mass_result.dart';
import '../../../utils/text.dart';
import '../../../constants.dart';

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
  MolecularMassResult _result = MolecularMassResult(
    true,
    97.96737971,
    {'H': 2.01588, 'S': 32.066, 'O': 63.976},
    {'H': 2, 'S': 1, 'O': 4},
    '',
  );

  Future<void> _calculate() async {
    String input = _textController.text;

    MolecularMassResult? result = await Api().getMolecularMass(toDigits(input));

    if (result != null) {
      if (result.present) {
        setState(() => _result = result);

        // UI/UX actions:
        _labelText = input; // Sets previous input as label
        _textController.clear(); // Clears input

        _textFocusNode.unfocus();
      } else {
        if (!mounted) return; // For security reasons
        DialogPopup.reportableMessage(
          title: 'Sin resultado',
          details: toSubscripts(result.error!),
        ).show(context);
      }
    } else {
      if (!mounted) return; // For security reasons
      const DialogPopup.message(
        title: 'Sin resultado',
      ).show(context);
    }
  }

  void _pressedButton() {
    _eraseInitialAndFinalBlanks();

    if (isEmptyWithBlanks(_textController.text)) {
      if (_textFocusNode.hasFocus) {
        _textController.clear(); // Clears input
      } else {
        _startTyping();
      }
    } else {
      _calculate();
    }
  }

  void _submittedText() {
    // Keyboard will be hidden afterwards
    _eraseInitialAndFinalBlanks();

    if (isEmptyWithBlanks(_textController.text)) {
      _textController.clear(); // Clears input
    } else {
      _calculate();
    }
  }

  void _tapOutsideText() {
    _textFocusNode.unfocus(); // Hides keyboard

    if (isEmptyWithBlanks(_textController.text)) {
      _textController.clear(); // Clears input
    } else {
      _eraseInitialAndFinalBlanks();
    }
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

  void _eraseInitialAndFinalBlanks() {
    _textController.text =
        noInitialAndFinalBlanks(_textController.text); // Clears input
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tapOutsideText,
      child: Container(
        decoration: quimifyGradientBoxDecoration,
        child: Scaffold(
          // To avoid keyboard resizing:
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // App bar:
              const PageAppBar(title: 'Masa molecular'),
              // Body:
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
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
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fórmula',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                TextField(
                                  // Aspect:
                                  cursorColor:
                                      Theme.of(context).colorScheme.primary,
                                  style: inputOutputStyle,
                                  keyboardType: TextInputType.visiblePassword,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 3),
                                    isCollapsed: true,
                                    labelText: _labelText,
                                    labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        inputFormatter)
                                  ],
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
                                  onSubmitted: (_) => _submittedText(),
                                  onTap: _scrollToStart,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Output(mass: _result.mass!),
                        const SizedBox(height: 25),
                        Button.gradient(
                          height: 50,
                          gradient: quimifyGradient,
                          onPressed: _pressedButton,
                          child: Text(
                            'Calcular',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GraphMenu(
                          mass: _result.mass!,
                          elementToGrams: _result.elementToGrams,
                          elementToMoles: _result.elementToMoles,
                        ),
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

const TextStyle inputOutputStyle = TextStyle(
  fontSize: 26,
  color: quimifyTeal,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Masa molecular',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const HelpButton(),
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
    List<GraphQuantity> gramQuantities = [];

    widget.elementToGrams.forEach((symbol, grams) {
      symbols.add(GraphSymbol(symbol: symbol));
      gramBars.add(GraphBar(quantity: grams, total: widget.mass));
      gramQuantities.add(GraphQuantity(quantity: '${grams.round()} g'));
    });

    String formula = '';
    List<GraphBar> molBars = [];
    List<GraphQuantity> molQuantities = [];

    int totalMoles = widget.elementToMoles.values.reduce((sum, i) => sum + i);
    widget.elementToMoles.forEach((symbol, moles) {
      formula += moles > 1 ? '$symbol$moles' : symbol;
      molBars.add(GraphBar(quantity: moles, total: totalMoles));
      molQuantities.add(GraphQuantity(quantity: '$moles mol'));
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
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
                      color: quimifyTeal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  stepGranularity: 0.1,
                  maxLines: 1,
                  style: TextStyle(
                    color: quimifyTeal,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                activeColor: Colors.white.withOpacity(0.9),
                inactiveThumbColor: Colors.white.withOpacity(0.9),
                activeTrackColor: quimifyTeal,
                inactiveTrackColor: Theme.of(context).colorScheme.secondary,
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
                  color: _mol
                      ? quimifyTeal
                      : Theme.of(context).colorScheme.secondary,
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
              Graph(
                symbols: symbols,
                bars: gramBars,
                quantities: gramQuantities,
              ),
              Graph(
                symbols: symbols,
                bars: molBars,
                quantities: molQuantities,
              ),
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

class GraphBar extends StatelessWidget {
  const GraphBar({Key? key, required this.quantity, required this.total})
      : super(key: key);

  final num quantity, total;

  @override
  Widget build(BuildContext context) {
    double proportion = quantity / total;

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onInverseSurface,
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
