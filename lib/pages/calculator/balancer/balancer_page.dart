import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/balancer_result.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/pages/calculator/balancer/widget/balancer_products_help_dialog.dart';
import 'package:quimify_client/pages/calculator/balancer/widget/balancer_reactants_help_dialog.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/history_field.dart';
import 'package:quimify_client/pages/history/history_page.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/dialogs/loading_indicator.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/help_button.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/storage/history/history.dart';
import 'package:quimify_client/text.dart';

class BalancerPage extends StatefulWidget {
  const BalancerPage({Key? key}) : super(key: key);

  @override
  State<BalancerPage> createState() => _BalancerPageState();
}

class _BalancerPageState extends State<BalancerPage> {
  final TextEditingController _reactantsController = TextEditingController();
  final TextEditingController _productsController = TextEditingController();
  final FocusNode _reactantsFocusNode = FocusNode();
  final FocusNode _productsFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  //final ScrollController _reactantsScrollController = ScrollController();
  //final ScrollController _productsScrollController = ScrollController(); These are not necessary
  //final ScrollController _solutionScrollController = ScrollController();
  //final TextEditingController _textController = TextEditingController();
  //final FocusNode _textFocusNode = FocusNode();

  bool _argumentRead = false;

  String _reactantsLabelText = 'C₆H₁₂O₆ + O₂';
  String _productsLabelText = 'CO₂ + H₂O';
  BalancerResult _result = BalancerResult(
    '',
    true,
    'C₆H₁₂O₆ + O₂ = CO₂ + H₂O',
    '1(C₆H₁₂O₆) + 6O₂ ⟶ 6(CO₂) + 6(H₂O)',
    '1(C₆H₁₂O₆) + 6O₂',
    '6(CO₂) + 6(H₂O)',
    null,
  );

  _calculate(String reactants, String products) async {
    showLoadingIndicator(context);
    String finalEquation = '$reactants = $products'; // This can be omitted

    // Result not found in cache, make an API call
    BalancerResult? result = await Api().getBalancedEquation(toDigits(finalEquation));

    if (result != null) {
      if (result.present) {
        Ads().showInterstitial();

        setState(() => _result = result);

        //History().saveBalancedEquation(result); // TODO I am getting an error here`

        // UI/UX actions:

        _reactantsLabelText = reactants; // Sets previous input as label
        _productsLabelText = products; // Sets previous input as label

        _reactantsController.clear();
        _productsController.clear();

        _productsFocusNode.unfocus();
        _reactantsFocusNode.unfocus();
      } else {
        if (!mounted) return; // For security reasons
        MessageDialog.reportable(
          title: 'Sin resultado',
          details: result.error != null ? toSubscripts(result.error!) : null,
          reportContext: 'Ajustar reacciones',
          reportDetails: 'Searched "$finalEquation"',
        ).show(context);
      }
    } else {
      if (!mounted) return; // For security reasons

      if (await hasInternetConnection()) {
        const MessageDialog(
          title: 'Sin resultado',
        ).show(context);
      } else {
        noInternetDialog.show(context);
      }
    }
    hideLoadingIndicator();
  }
  //TODO addapt this
  _showHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HistoryPage(
          onStartPressed: () => _reactantsFocusNode.requestFocus(),
          entries: History()
              .getBalancedEquation()
              .map((e) => HistoryEntry(
            query: toSubscripts(e.formula),
            fields: [
              HistoryField(
                'Reacción',
                toSubscripts(e.formula),
              ),
              HistoryField(
                'Reacción ajustada',
                '${(e.balancedEquation)}', //TODO format
              ),
            ],
          ))
              .toList(),
          onEntryPressed: (formula) => _calculate(_reactantsController.text, _productsController.text),
        ),
      ),
    );
  }

  // Interface:

  void _pressedButton() {
    _eraseInitialAndFinalBlanks(); // This may need to be adapted to handle both fields.

    // Check if both fields are empty, even with blanks
    bool reactantsEmpty = isEmptyWithBlanks(_reactantsController.text);
    bool productsEmpty = isEmptyWithBlanks(_productsController.text);

    if (reactantsEmpty && productsEmpty) {
      _reactantsController.clear(); // Clears reactants input
      _productsController.clear(); // Clears products input
      _reactantsFocusNode.requestFocus();
    }
    else if (productsEmpty){
      _productsController.clear(); // Clears products input
      _productsFocusNode.requestFocus();
    } else {
      _calculate(_reactantsController.text, _productsController.text);
    }
  }

  _submittedText() {
    // Keyboard will be hidden afterwards
    _eraseInitialAndFinalBlanks();

    if (isEmptyWithBlanks(_reactantsController.text)) {
      _reactantsController.clear(); // Clears input
    }
    else if(isEmptyWithBlanks(_productsController.text)){
      _productsController.clear(); // Clears input
    }
    else {
      _calculate(_reactantsController.text, _productsController.text);
    }
  }

  _tappedOutsideText() {
    _reactantsFocusNode.unfocus(); // Hides keyboard
    _productsFocusNode.unfocus(); // Hides keyboard

    if (isEmptyWithBlanks(_reactantsController.text)) {
      _reactantsController.clear(); // Clears input
    } else {
      _eraseInitialAndFinalBlanks();
    }

    if (isEmptyWithBlanks(_productsController.text)) {
      _productsController.clear(); // Clears input
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

  _startTypingReactant() {
    // Like if the TextField was tapped:
    _reactantsFocusNode.requestFocus();
    _scrollToStart();
  }

  _startTypingProduct() {
    // Like if the TextField was tapped:
    _productsFocusNode.requestFocus();
    _scrollToStart();
  }

  void _eraseInitialAndFinalBlanks() {
    _reactantsController.text = noInitialAndFinalBlanks(_reactantsController.text);
    _productsController.text = noInitialAndFinalBlanks(_productsController.text);
  }

  _pressedShareButton(BuildContext context) => comingSoonDialog.show(context);

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50;

    String? argument = ModalRoute.of(context)?.settings.arguments as String?;

    if (argument != null && !_argumentRead) {
      _reactantsFocusNode.requestFocus();
      _argumentRead = true;
    }

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          return;
        }

        hideLoadingIndicator();
      },
      child: GestureDetector(
        onTap: _tappedOutsideText,
        child: QuimifyScaffold(
          bannerAdName: runtimeType.toString(),
          header: const QuimifyPageBar(title: 'Ajustar reacciones'),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _startTypingReactant, // As if the TextField was tapped
                  child: Container( // Reactants Container
                    height: 110,
                    decoration: BoxDecoration(
                      color: QuimifyColors.foreground(context),
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
                              'Reactivos',
                              style: TextStyle(
                                fontSize: 18,
                                color: QuimifyColors.primary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const HelpButton(
                              dialog: BalancerReactantHelpDialog(),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextField(
                          autocorrect: false,
                          enableSuggestions: false,
                          // Aspect:
                          cursorColor: QuimifyColors.primary(context),
                          style: TextStyle(
                            fontSize: 26,
                            color: QuimifyColors.primary(context),
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 3),
                            isCollapsed: true,
                            labelText: _reactantsLabelText,
                            labelStyle: TextStyle(
                              color: QuimifyColors.tertiary(context),
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
                              balancerInputFormatter,
                            ),
                          ],
                          textCapitalization: TextCapitalization.sentences,
                          scribbleEnabled: false,
                          focusNode: _reactantsFocusNode,
                          controller: _reactantsController,
                          onChanged: (String input) {
                            _reactantsController.value = _reactantsController.value
                                .copyWith(text: formatBalancerInput(input));
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
                const Icon(Icons.arrow_downward_sharp, size: 35),
                const SizedBox(height: 15),

                GestureDetector(
                  onTap: _startTypingProduct, // As if the TextField was tapped
                  child: Container( // Products Container
                    height: 110,
                    decoration: BoxDecoration(
                      color: QuimifyColors.foreground(context),
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
                              'Productos',
                              style: TextStyle(
                                fontSize: 18,
                                color: QuimifyColors.primary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const HelpButton(
                              dialog: BalancerProductHelpDialog(),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextField(
                          autocorrect: false,
                          enableSuggestions: false,
                          // Aspect:
                          cursorColor: QuimifyColors.primary(context),
                          style: TextStyle(
                            fontSize: 26,
                            color: QuimifyColors.primary(context),
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 3),
                            isCollapsed: true,
                            labelText: _productsLabelText,
                            labelStyle: TextStyle(
                              color: QuimifyColors.tertiary(context),
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
                              balancerInputFormatter,
                            ),
                          ],
                          textCapitalization: TextCapitalization.sentences,
                          scribbleEnabled: false,
                          focusNode: _productsFocusNode,
                          controller: _productsController,
                          onChanged: (String input) {
                            _productsController.value = _productsController.value
                                .copyWith(text: formatBalancerInput(input));
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
                const Icon(Icons.done_sharp, size: 35),
                const SizedBox(height: 15),

                Container(
                  height: 115,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: QuimifyColors.foreground(context),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Reacción ajustada',
                            style: TextStyle(
                              fontSize: 18,
                              color: QuimifyColors.primary(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            color: QuimifyColors.primary(context),
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
                        formatBalancer('${_result.balancedReactants} ⟶ ${_result.balancedProducts!}'),
                        stepGranularity: 0.1,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 26,
                          color: QuimifyColors.teal(),
                          fontWeight: FontWeight.bold,
                        ),
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
                          'Ajustar',
                          style: TextStyle(
                            color: QuimifyColors.inverseText(context),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
