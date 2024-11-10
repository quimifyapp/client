import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/equation_result.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/pages/calculator/equation/widgets/equation_input_help_dialog.dart';
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
import 'package:quimify_client/subsription_service.dart';
import 'package:quimify_client/text.dart';

class EquationPage extends StatefulWidget {
  const EquationPage({Key? key}) : super(key: key);

  @override
  State<EquationPage> createState() => _EquationPageState();
}

class _EquationPageState extends State<EquationPage> {
  final _subscriptionService = getIt<SubscriptionService>();
  bool _isSubscribed = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _isSubscribed = _subscriptionService.isSubscribed;
    _subscription =
        _subscriptionService.subscriptionStream.listen((isSubscribed) {
      if (mounted) {
        setState(() {
          _isSubscribed = isSubscribed;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  final TextEditingController _reactantsController = TextEditingController();
  final TextEditingController _productsController = TextEditingController();
  final FocusNode _reactantsFocusNode = FocusNode();
  final FocusNode _productsFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _reactantsLabelText = 'C₆H₁₂O₆ + O₂';
  String _productsLabelText = 'CO₂ + H₂O';
  EquationResult _result = EquationResult(
    true,
    'C₆H₁₂O₆ + 6O₂',
    '6(CO₂) + 6(H₂O)',
    null,
  );

  _calculate(String reactants, String products) async {
    showLoadingIndicator(context);

    EquationResult? result =
        await Api().getEquation(toDigits(reactants), toDigits(products));

    if (result != null) {
      if (result.present) {
        if (!_isSubscribed) {
          Ads().showInterstitial(
            onDismissed: () {
              RevenueCatUI.presentPaywallIfNeeded('Premium');
            },
          );
        }

        setState(() => _result = result);

        History().saveEquation(result, reactants, products);

        // UI/UX actions:

        _reactantsLabelText = reactants; // Sets previous input as label
        _productsLabelText = products; // Sets previous input as label

        _reactantsController.clear();
        _productsController.clear();

        _reactantsFocusNode.unfocus();
        _productsFocusNode.unfocus();
      } else {
        if (!mounted) return; // For security reasons
        MessageDialog.reportable(
          title: 'Sin resultado',
          details: result.error != null ? toSubscripts(result.error!) : null,
          reportContext: 'Equation',
          reportDetails: 'Searched ${toEquation(reactants, products)}',
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

  _showHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HistoryPage(
          onStartPressed: _startTyping,
          entries: History()
              .getEquations()
              .map(
                (e) => HistoryEntry(
                  query: [
                    formatEquation(e.originalReactants),
                    formatEquation(e.originalProducts),
                  ],
                  fields: [
                    HistoryField(
                      'Reacción',
                      formatEquation(
                        toEquation(e.originalReactants, e.originalProducts),
                      ),
                    ),
                    HistoryField(
                      'Reacción ajustada',
                      formatEquation(
                        toEquation(e.balancedReactants, e.balancedProducts),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          onEntryPressed: (query) => _calculate(query[0], query[1]),
        ),
      ),
    );
  }

  // Interface:

  void _pressedButton() {
    _eraseInitialAndFinalBlanks();

    // Check if both fields are empty, even with blanks
    bool reactantsEmpty = isEmptyWithBlanks(_reactantsController.text);
    bool productsEmpty = isEmptyWithBlanks(_productsController.text);

    if (!reactantsEmpty && !productsEmpty) {
      _calculate(_reactantsController.text, _productsController.text);
    } else {
      _startTyping();
    }
  }

  _submittedText() {
    // Keyboard will be hidden afterwards
    _eraseInitialAndFinalBlanks();

    if (isEmptyWithBlanks(_reactantsController.text)) {
      _reactantsController.clear();
    } else if (isEmptyWithBlanks(_productsController.text)) {
      _productsController.clear();
    } else {
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

  _startTyping() {
    _scrollToStart();

    if (isEmptyWithBlanks(_reactantsController.text)) {
      _reactantsFocusNode.requestFocus();
    } else {
      _productsFocusNode.requestFocus();
    }
  }

  void _eraseInitialAndFinalBlanks() {
    _reactantsController.text =
        noInitialAndFinalBlanks(_reactantsController.text);

    _productsController.text =
        noInitialAndFinalBlanks(_productsController.text);
  }

  _pressedShareButton(BuildContext context) => comingSoonDialog.show(context);

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50;

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
          header: const QuimifyPageBar(title: 'Balancear reacción'),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _startTyping,
                  child: Container(
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
                              'Reacción',
                              style: TextStyle(
                                fontSize: 18,
                                color: QuimifyColors.primary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const HelpButton(
                              dialog: EquationInputHelpDialog(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
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
                              equationInputFormatter,
                            ),
                          ],
                          textCapitalization: TextCapitalization.sentences,
                          scribbleEnabled: false,
                          focusNode: _reactantsFocusNode,
                          controller: _reactantsController,
                          onChanged: (String input) {
                            _reactantsController.value = _reactantsController
                                .value
                                .copyWith(text: formatEquationInput(input));
                          },
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _submittedText(),
                          onTap: _scrollToStart,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '⟶',
                          style: TextStyle(
                            fontSize: 26,
                            color: QuimifyColors.primary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                              equationInputFormatter,
                            ),
                          ],
                          textCapitalization: TextCapitalization.sentences,
                          scribbleEnabled: false,
                          focusNode: _productsFocusNode,
                          controller: _productsController,
                          onChanged: (String input) {
                            _productsController.value = _productsController
                                .value
                                .copyWith(text: formatEquationInput(input));
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
                const SizedBox(height: 20),
                Container(
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
                      const SizedBox(height: 15),
                      AutoSizeText(
                        formatEquation(_result.balancedReactants!),
                        stepGranularity: 0.1,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 26,
                          color: QuimifyColors.teal(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '⟶',
                        style: TextStyle(
                          fontSize: 26,
                          color: QuimifyColors.primary(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        formatEquation(_result.balancedProducts!),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
