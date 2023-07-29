import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/api/ads.dart';
import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/local/history.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph_selector.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/molecular_mass_help_dialog.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/history_page.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/help_button.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/internet.dart';
import 'package:quimify_client/utils/text.dart';

class MolecularMassPage extends StatefulWidget {
  const MolecularMassPage({Key? key}) : super(key: key);

  @override
  State<MolecularMassPage> createState() => _MolecularMassPageState();
}

class _MolecularMassPageState extends State<MolecularMassPage> {
  late bool _isBannerAdLoaded = false;
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

  @override
  didChangeDependencies() {
    // TODO review
    super.didChangeDependencies();

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final bannerAdWidth = screenWidth - 40;

    AdManager.loadBannerAd(bannerAdWidth).then((_) {
      setState(() {
        _isBannerAdLoaded = true;
      });
    });
  }

  @override
  dispose() {
    // TODO review
    AdManager.disposeBannerAd();
    super.dispose();
  }

  void _calculate(String input) async {
    startQuimifyLoading(context);

    // Result not found in cache, make an API call
    MolecularMassResult? result = await Api().getMolecularMass(toDigits(input));

    stopQuimifyLoading();

    if (result != null) {
      if (result.present) {
        AdManager.showInterstitialAd();

        setState(() => _result = result);

        History.saveMolecularMass(result);

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
      hasInternetConnection().then(
        (bool hasInternetConnection) {
          if (hasInternetConnection) {
            const QuimifyMessageDialog(
              title: 'Sin resultado',
            ).show(context);
          } else {
            quimifyNoInternetDialog.show(context);
          }
        },
      );
    }
  }

  _showHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HistoryPage(
          entries: History.getMolecularMasses()
              .map((e) => HistoryEntry(
                    query: e.formula,
                    fields: {
                      'Fórmula': toSubscripts(e.formula),
                      'Masa molecular': e.molecularMass.toString(),
                    },
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
          header: const QuimifyPageBar(title: 'Masa molecular'),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 5),
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
                const SizedBox(height: 25),
                Row(
                  children: [
                    HistoryButton(
                      height: buttonHeight,
                      onPressed: _showHistory,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuimifyButton.gradient(
                        height: buttonHeight,
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
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                GraphSelector(
                  mass: _result.molecularMass!,
                  elementToGrams: _result.elementToGrams!,
                  elementToMoles: _result.elementToMoles!,
                ),
                const SizedBox(height: 25),
                Container(
                  color: Theme.of(context).colorScheme.background,
                  width: double.infinity,
                  height: _isBannerAdLoaded
                      ? AdManager.getBannerAd()?.size.height.toDouble()
                      : 0,
                  child: _isBannerAdLoaded
                      ? AdWidget(ad: AdManager.getBannerAd()!)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
