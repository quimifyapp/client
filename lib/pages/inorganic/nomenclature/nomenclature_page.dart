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
import 'package:quimify_client/routes.dart';
import 'package:quimify_client/storage/history/history.dart';
import 'package:quimify_client/text.dart';

class NomenclaturePage extends StatefulWidget {
  const NomenclaturePage({Key? key}) : super(key: key);

  @override
  State<NomenclaturePage> createState() => _NomenclaturePageState();
}

class _NomenclaturePageState extends State<NomenclaturePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  late String _labelText;
  late List<InorganicResultView> _resultViews;

  static final Map<String, String> _normalizedToCompletion = {};
  static final Set<String> _completionNotFoundNormalizedInputs = {};

  // Constants:

  static const String _defaultLabelText = 'NaCl, óxido de hierro...';

  static final _defaultResultView = InorganicResultView(
    formattedQuery: 'NaCl',
    result: InorganicResult(
      true,
      null,
      null,
      'NaCl',
      'cloruro de sodio',
      'monocloruro de sodio',
      'cloruro sódico',
      'sal de mesa',
      '58.35',
      '2.16',
      '1074.15',
      '1686.15',
    ),
  );

  // TODO mejorar textos:

  static const String messageRoot = 'Parece que estás intentando resolver un';

  static const Map<Classification, String> classificationToMessage = {
    Classification.organicFormula: '$messageRoot *compuesto orgánico*.',
    Classification.organicName: '$messageRoot *compuesto orgánico*.',
    Classification.molecularMassProblem: '${messageRoot}a *masa molecular*.',
    Classification.chemicalProblem: '$messageRoot *problema químico*.',
    Classification.chemicalReaction: '${messageRoot}a *reacción química*.',
  };

  @override
  initState() {
    super.initState();

    _labelText = _defaultLabelText;

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

  _showNotFoundDialog(String formattedQuery) {
    MessageDialog.reportable(
      title: 'Sin resultado',
      details: 'No se ha encontrado:\n"$formattedQuery"',
      reportContext: 'Inorganic naming and finding formula',
      reportDetails: 'Searched "$formattedQuery"',
    ).show(context);
  }

  _processNotFound(InorganicResult? result, String formattedQuery) async {
    if (result == null) {
      await hasInternetConnection()
          ? const MessageDialog(title: 'Sin resultado').show(context)
          : noInternetDialog.show(context);

      return;
    }

    if (result.classification == null) {
      _showNotFoundDialog(formattedQuery);
      return;
    }

    // TODO mejorar textos:

    if (result.classification == Classification.nomenclatureProblem) {
      MessageDialog(
        title: 'Casi lo tienes',
        details: 'Introduce sólo la *fórmula* o *nombre* que quieras resolver.',
        onButtonPressed: () => _textFocusNode.requestFocus(),
      ).show(context);
      return;
    }

    bool classificationHasRoute = Routes.contains(result.classification!);

    ClassificationDialog(
      richText: classificationToMessage[result.classification!]!,
      closeOnAgree: !classificationHasRoute,
      onPressedAgree: () {
        if (classificationHasRoute) {
          Navigator.pushNamed(
            context,
            Routes.fromClassification[result.classification!]!,
            arguments: toDigits(formattedQuery),
          );
        } else if (result.classification == Classification.chemicalProblem) {
          // TODO explicar qué SÍ puede hacer Quimify?
          // TODO hacer más comprensible? "próximas actualizaciones"
          // TODO un sólo mensaje para problemas / reacciones?
          const MessageDialog(
            title: '¡Estamos en ello!',
            details: 'Podremos resolver problemas químicos en próximas '
                'actualizaciones.',
          ).show(context);
        } else if (result.classification == Classification.chemicalReaction) {
          const MessageDialog(
            title: '¡Estamos en ello!',
            details: 'Podremos resolver reacciones químicas en próximas '
                'actualizaciones.',
          ).show(context);
        }
      },
      onPressedDisagree: () => _deepSearch(formattedQuery),
    ).show(context);
  }

  _processResult(InorganicResult? result, String formattedQuery) async {
    if (result == null || !result.found) {
      _processNotFound(result, formattedQuery);
      return;
    }

    // TODO handle suggestions

    setState(
      () => _resultViews.add(
        InorganicResultView(
          formattedQuery: formattedQuery,
          result: result,
        ),
      ),
    );

    History().saveInorganic(result, formattedQuery);

    // UI/UX actions:

    _labelText = formattedQuery; // Sets previous input as label
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

    if (result != null && result.found && result.suggestion == null) {
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
              const QuimifyPageBar(title: 'Nomenclatura inorgánica'),
              QuimifySearchBar(
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
