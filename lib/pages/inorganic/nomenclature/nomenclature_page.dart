import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/classification.dart';
import 'package:quimify_client/internet/api/results/inorganic_result.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_search_bar.dart';
import 'package:quimify_client/pages/widgets/dialogs/loading_indicator.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/suggestions/classification_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/storage/history/history.dart';
import 'package:quimify_client/text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class NomenclaturePage extends StatefulWidget {
  const NomenclaturePage({Key? key}) : super(key: key);

  @override
  State<NomenclaturePage> createState() => _NomenclaturePageState();
}

class _NomenclaturePageState extends State<NomenclaturePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  bool _argumentRead = false;
  bool _isInitialized = false;

  late String _labelText;
  late List<InorganicResultView> _resultViews;
  late final InorganicResultView _defaultResultView;

  static final Map<String, String> _normalizedToCompletion = {};
  static final Set<String> _completionNotFoundNormalizedInputs = {};

  // Constants:
  // static const String _messageRoot = 'Parece que estás intentando resolver un';

  Map<Classification, String> _classificationToMessage = {};

  // didChangeDependencies:

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    _labelText = context.l10n.naclIronOxide;

    // Initialize _defaultResultView
    _defaultResultView = InorganicResultView(
      formattedQuery: 'NaCl',
      result: InorganicResult(
        true,
        null,
        null,
        'NaCl',
        context.l10n.sodiumChloride,
        context.l10n.sodiumMonoChloride,
        context.l10n.cloruroSodico,
        context.l10n.tableSalt,
        '58.35',
        '2.16',
        '1074.15',
        '1686.15',
      ),
    );

    // Now populate _resultViews (moved from initState)
    _resultViews = History()
        .getInorganics()
        .reversed
        .map((localResult) => InorganicResultView(
              formattedQuery: localResult.formattedQuery,
              result: InorganicResult.fromLocal(localResult),
            ))
        .toList();

    if (_resultViews.isEmpty) {
      _resultViews.add(_defaultResultView);
    }

    // Classification messages
    _classificationToMessage = {
      Classification.organicFormula:
          context.l10n.itLooksLikeYouAreTryingToSolveAnOrganicCompoundFormula,
      Classification.organicName:
          context.l10n.itLooksLikeYouAreTryingToSolveAnOrganicCompoundName,
      Classification.molecularMassProblem:
          context.l10n.itLooksLikeYouAreTryingToSolveAMolecularMassProblem,
      Classification.chemicalProblem:
          context.l10n.itLooksLikeYouAreTryingToSolveAChemicalProblem,
      Classification.chemicalReaction:
          context.l10n.itLooksLikeYouAreTryingToSolveAChemicalReaction,
    };

    _isInitialized = true;
  }

  @override
  initState() {
    super.initState();

    // Initialize _resultViews as an empty list first
    _resultViews = [];

    // We'll populate this after didChangeDependencies is called
    // DO NOT reference _defaultResultView here
  }

  _storeCompletionInCache(String? completion, String normalizedInput) {
    if (completion != null) {
      completion == ''
          ? _completionNotFoundNormalizedInputs.add(normalizedInput)
          : _normalizedToCompletion[_normalize(completion)] = completion;
    }
  }

  // Looks for a previous completion that could complete this input too
  String? _getFromFoundCompletionsCache(String normalizedInput) {
    String? key = _normalizedToCompletion.keys.firstWhereOrNull(
        (cachedNormalizedCompletion) =>
            cachedNormalizedCompletion.startsWith(normalizedInput));

    return key != null ? _normalizedToCompletion[key] : null;
  }

  // Checks if this input is an extension of an uncompleted previous input
  bool _isInNotFoundCompletionsCache(String normalizedInput) =>
      _completionNotFoundNormalizedInputs.any(
          (cachedNormalizedInput) => normalizedInput == cachedNormalizedInput);

  String _normalize(String text) => removeDiacritics(text)
      .replaceAll(RegExp(r'[^\x00-\x7F]'), '') // Only ASCII
      .replaceAll(RegExp(r'[^A-Za-z0-9]'), '') // Only alphanumeric
      .toLowerCase();

  Future<String?> _getCompletion(String input) async {
    String? completion;

    String inputWithoutSubscripts = toDigits(input);
    String normalizedInput = _normalize(inputWithoutSubscripts);

    if (!_isInNotFoundCompletionsCache(normalizedInput)) {
      completion = _getFromFoundCompletionsCache(normalizedInput);

      if (completion == null) {
        completion = await Api().getInorganicCompletion(inputWithoutSubscripts);
        _storeCompletionInCache(completion, normalizedInput);
      }
    }

    return completion;
  }

  _processClassification(Classification classification, String formattedQuery) {
    if (classification == Classification.nomenclatureProblem) {
      MessageDialog(
        title: context.l10n.almostThere,
        details: context.l10n.enterOnlyTheFormulaOrNameYouWantToSolve,
        onButtonPressed: () => _textFocusNode.requestFocus(),
      ).show(context);
      return;
    }

    ClassificationDialog(
      classification: classification,
      formattedQuery: formattedQuery,
      richText: _classificationToMessage[classification]!,
      onPressedDisagree: () => _deepSearch(formattedQuery),
    ).show(context);
  }

  _showNotFoundDialog(String formattedQuery) {
    MessageDialog.reportable(
      title: context.l10n.noResult,
      details: '${context.l10n.notFound}:\n"$formattedQuery"',
      reportContext: context.l10n.inorganicNamingAndFindingFormula,
      reportDetails: '${context.l10n.searched} "$formattedQuery"',
    ).show(context);
  }

  _processNotFound(InorganicResult? result, String formattedQuery) async {
    if (result == null) {
      await hasInternetConnection()
          ? MessageDialog(title: context.l10n.noResult).show(context)
          : noInternetDialog(context).show(context);

      return;
    }

    if (result.classification != null) {
      _processClassification(result.classification!, formattedQuery);
    } else {
      _showNotFoundDialog(formattedQuery);
    }
  }

  _processResult(InorganicResult? result, String formattedQuery) async {
    if (result == null || !result.found) {
      _processNotFound(result, formattedQuery);
      return;
    }

    setState(() {
      _resultViews.add(
        InorganicResultView(
          formattedQuery: formattedQuery,
          result: result,
        ),
      );
      _labelText = formattedQuery; // Sets previous input as label
    });

    History().saveInorganic(result, formattedQuery);

    // UI/UX actions:
    _textController.clear(); // Clears input
    _textFocusNode.unfocus(); // Hides keyboard
    _scrollToStart(); // Goes to the top of the page
  }

  _deepSearch(String formattedQuery) async {
    showLoadingIndicator(context);

    var result = await Api().deepSearchInorganic(toDigits(formattedQuery));

    await _processResult(result, formattedQuery);

    hideLoadingIndicator();
  }

  _searchFromQuery(String formattedQuery) async {
    if (isEmptyWithBlanks(formattedQuery)) {
      return;
    }

    showLoadingIndicator(context);

    var result = await Api().searchInorganic(toDigits(formattedQuery));

    if (result != null && result.found) {
      Ads().showInterstitial();
    }

    await _processResult(result, formattedQuery);

    hideLoadingIndicator();
  }

  _searchFromCompletion(String completion) async {
    if (isEmptyWithBlanks(completion)) {
      return;
    }

    Ads().showInterstitial(); // There will be a result most of the times

    showLoadingIndicator(context);

    var result = await Api().getInorganicFromCompletion(completion);

    await _processResult(result, formatInorganicFormulaOrName(completion));

    hideLoadingIndicator();
  }

  _scrollToStart() {
    // Goes to the top of the page after a delay:
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? argument = ModalRoute.of(context)?.settings.arguments as String?;

    if (argument != null && !_argumentRead) {
      _textController.text = formatOrganicName(argument);
      _textFocusNode.requestFocus();
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
        onTap: _textFocusNode.unfocus,
        child: QuimifyScaffold(
          bannerAdName: runtimeType.toString(),
          showBannerAd: true,
          header: Column(
            children: [
              QuimifyPageBar(title: context.l10n.inorganicNomenclature),
              QuimifySearchBar(
                isOrganic: false,
                label: _labelText,
                textEditingController: _textController,
                focusNode: _textFocusNode,
                inputCorrector: formatInorganicFormulaOrName,
                onSubmitted: (input) => _searchFromQuery(input),
                completionCorrector: formatInorganicFormulaOrName,
                completionCallBack: _getCompletion,
                onCompletionPressed: _searchFromCompletion,
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Wrap(
              verticalDirection: VerticalDirection.up,
              runSpacing: 25,
              children: _resultViews,
            ),
          ),
        ),
      ),
    );
  }
}
