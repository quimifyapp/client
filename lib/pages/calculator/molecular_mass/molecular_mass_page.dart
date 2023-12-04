import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/molecular_mass_result.dart';
import 'package:quimify_client/storage/history/history.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph_selector.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/molecular_mass_help_dialog.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/history_field.dart';
import 'package:quimify_client/pages/history/history_page.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/help_button.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/text/text.dart';

class MolecularMassPage extends StatefulWidget {
  const MolecularMassPage({Key? key}) : super(key: key);

  @override
  State<MolecularMassPage> createState() => _MolecularMassPageState();
}

class _MolecularMassPageState extends State<MolecularMassPage> {
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Initial values:

  String _labelText = 'H₂SO₄';
  MolecularMassResult _result = MolecularMassResult(
    true,
    'H₂SO₄',
    97.96737971,
    {'H': 2.01588, 'S': 32.066, 'O': 63.976},
    {'H': 2, 'S': 1, 'O': 4},
    null,
  );

  _calculate(String input) async {
    startQuimifyLoading(context);

    // Result not found in cache, make an API call
    MolecularMassResult? result = await Api().getMolecularMass(toDigits(input));

    if (result != null) {
      if (result.present) {
        Ads().showInterstitial();

        setState(() => _result = result);

        History().saveMolecularMass(result);

        // UI/UX actions:

        _labelText = input; // Sets previous input as label
        _textController.clear(); // Clears input

        _textFocusNode.unfocus();
      } else {
        if (!mounted) return; // For security reasons
        QuimifyMessageDialog.reportable(
          title: 'Sin resultado',
          details: result.error != null ? toSubscripts(result.error!) : null,
          reportContext: 'Molecular mass',
          reportDetails: 'Searched "$input"',
        ).show(context);
      }
    } else {
      if (!mounted) return; // For security reasons

      if (await hasInternetConnection()) {
        const QuimifyMessageDialog(
          title: 'Sin resultado',
        ).show(context);
      } else {
        quimifyNoInternetDialog.show(context);
      }
    }

    stopQuimifyLoading();
  }

  _showHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HistoryPage(
          entries: History()
              .getMolecularMasses()
              .map((e) => HistoryEntry(
                    query: toSubscripts(e.formula),
                    fields: [
                      HistoryField(
                        'Búsqueda',
                        toSubscripts(e.formula),
                      ),
                      HistoryField(
                        'Masa molecular',
                        '${e.molecularMass.toString()} g/mol',
                      ),
                    ],
                  ))
              .toList(),
          onEntryPressed: (formula) => _calculate(formula),
        ),
      ),
    );
  }

  // Interface:

  _pressedButton() {
    _eraseInitialAndFinalBlanks();

    if (isEmptyWithBlanks(_textController.text)) {
      if (_textFocusNode.hasFocus) {
        _textController.clear(); // Clears input
      } else {
        _startTyping();
      }
    } else {
      _calculate(_textController.text);
    }
  }

  _submittedText() {
    // Keyboard will be hidden afterwards
    _eraseInitialAndFinalBlanks();

    if (isEmptyWithBlanks(_textController.text)) {
      _textController.clear(); // Clears input
    } else {
      _calculate(_textController.text);
    }
  }

  _tappedOutsideText() {
    _textFocusNode.unfocus(); // Hides keyboard

    if (isEmptyWithBlanks(_textController.text)) {
      _textController.clear(); // Clears input
    } else {
      _eraseInitialAndFinalBlanks();
    }
  }

  _scrollToStart() {
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

  _startTyping() {
    // Like if the TextField was tapped:
    _textFocusNode.requestFocus();
    _scrollToStart();
  }

  _eraseInitialAndFinalBlanks() {
    _textController.text =
        noInitialAndFinalBlanks(_textController.text); // Clears input
  }

  _pressedShareButton(BuildContext context) =>
      quimifyComingSoonDialog.show(context);

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50;

    TextStyle inputOutputStyle = const TextStyle(
      fontSize: 26,
      color: quimifyTeal,
      fontWeight: FontWeight.bold,
    );

    return WillPopScope(
      onWillPop: () async {
        stopQuimifyLoading();
        return true;
      },
      child: GestureDetector(
        onTap: _tappedOutsideText,
        child: QuimifyScaffold(
          bannerAdName: runtimeType.toString(),
          header: const QuimifyPageBar(title: 'Masa molecular'),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _startTyping, // As if the TextField was tapped
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
                        Row(
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
                            const HelpButton(
                              dialog: MolecularMassHelpDialog(),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextField(
                          autocorrect: false,
                          enableSuggestions: false,
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
                              formulaInputFormatter,
                            ),
                          ],
                          textCapitalization: TextCapitalization.sentences,
                          scribbleEnabled: false,
                          focusNode: _textFocusNode,
                          controller: _textController,
                          onChanged: (String input) {
                            _textController.value = _textController.value
                                .copyWith(text: formatStructureInput(input));
                          },
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _submittedText(),
                          onTap: _scrollToStart,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
                          IconButton(
                            color: Theme.of(context).colorScheme.primary,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            // To remove padding:
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _pressedShareButton(context),
                            icon: const Icon(Icons.share_outlined, size: 26),
                          ),
                        ],
                      ),
                      const Spacer(),
                      AutoSizeText(
                        '${formatMolecularMass(_result.molecularMass!)} g/mol',
                        stepGranularity: 0.1,
                        maxLines: 1,
                        style: inputOutputStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    HistoryButton(
                      height: buttonHeight,
                      onPressed: _showHistory,
                    ),
                    const SizedBox(width: 12.5),
                    Expanded(
                      child: QuimifyButton.gradient(
                        height: buttonHeight,
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GraphSelector(
                  mass: _result.molecularMass!,
                  elementToGrams: _result.elementToGrams!,
                  elementToMoles: _result.elementToMoles!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
