import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/api/api.dart';
import 'package:cliente/api/results/molecular_mass_result.dart';
import 'package:cliente/pages/calculator/molecular_mass/widgets/graph_selector.dart';
import 'package:cliente/pages/widgets/appearance/quimify_gradient.dart';
import 'package:cliente/pages/widgets/appearance/quimify_teal.dart';
import 'package:cliente/pages/widgets/bars/quimify_page_bar.dart';
import 'package:cliente/pages/widgets/objects/quimify_help_button.dart';
import 'package:cliente/pages/widgets/popups/quimify_loading.dart';
import 'package:cliente/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:cliente/utils/text.dart';
import 'package:cliente/pages/widgets/objects/quimify_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    null,
  );

  Future<void> _calculate() async {
    String input = _textController.text;

    startLoading(context);

    MolecularMassResult? result = await Api().getMolecularMass(toDigits(input));

    stopLoading();

    if (result != null) {
      if (result.present) {
        setState(() => _result = result);

        // UI/UX actions:
        _labelText = input; // Sets previous input as label
        _textController.clear(); // Clears input

        _textFocusNode.unfocus();
      } else {
        if (!mounted) return; // For security reasons
        QuimifyMessageDialog.report(
          title: 'Sin resultado',
          details: toSubscripts(result.error!),
          reportLabel: 'Masa molecular ("$input")',
        ).show(context);
      }
    } else {
      // Client already reported an error in this case
      if (!mounted) return; // For security reasons
      const QuimifyMessageDialog(
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

  TextStyle inputOutputStyle = const TextStyle(
    fontSize: 26,
    color: quimifyTeal,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stopLoading();
        return true;
      },
      child: GestureDetector(
        onTap: _tapOutsideText,
        child: QuimifyScaffold(
          header: const QuimifyPageBar(title: 'Masa molecular'),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _startTyping(), // As if the TextField was tapped
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
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        TextField(
                          // Aspect:
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: inputOutputStyle,
                          keyboardType: TextInputType.visiblePassword,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 3),
                            isCollapsed: true,
                            labelText: _labelText,
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            // So hint doesn't go up while typing:
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                              inputFormatter,
                            ),
                          ],
                          textCapitalization: TextCapitalization.sentences,
                          scribbleEnabled: false,
                          focusNode: _textFocusNode,
                          controller: _textController,
                          onChanged: (input) {
                            _textController.value =
                                _textController.value.copyWith(
                              text: formatStructureInput(input),
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
                Container(
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
                        '${_result.mass!.toStringAsFixed(3)} g/mol',
                        stepGranularity: 0.1,
                        maxLines: 1,
                        style: inputOutputStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                QuimifyButton.gradient(
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
                GraphSelector(
                  mass: _result.mass!,
                  elementToGrams: _result.elementToGrams,
                  elementToMoles: _result.elementToMoles,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
