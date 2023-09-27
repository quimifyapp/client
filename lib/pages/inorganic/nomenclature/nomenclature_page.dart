import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/api/ads.dart';
import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/local/history.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_search_bar.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/quimify_internet.dart';
import 'package:quimify_client/utils/quimify_responsive.dart';
import 'package:quimify_client/utils/quimify_text.dart';

class NamingAndFindingFormulaPage extends StatefulWidget {
  const NamingAndFindingFormulaPage({Key? key}) : super(key: key);

  @override
  State<NamingAndFindingFormulaPage> createState() =>
      _NamingAndFindingFormulaPageState();
}

class _NamingAndFindingFormulaPageState
    extends State<NamingAndFindingFormulaPage> {
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

  @override
  void initState() {
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
        (String normalizedCompletion) =>
            normalizedCompletion.startsWith(normalizedInput));

    return key != null ? _normalizedToCompletion[key] : null;
  }

  // Checks if this input is an extension of an uncompleted previous input
  bool _isInNotFoundCompletionsCache(String normalizedInput) =>
      _completionNotFoundNormalizedInputs
          .where((previousInput) => normalizedInput.startsWith(previousInput))
          .isNotEmpty;

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

  _processResult(InorganicResult? result, String formattedQuery) async {
    if (result != null) {
      if (result.present) {
        Ads().showInterstitialAd();

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
      } else {
        QuimifyMessageDialog.reportable(
          title: 'Sin resultado',
          details: 'No se ha encontrado:\n"$formattedQuery"',
          reportContext: 'Inorganic naming and finding formula',
          reportDetails: 'Searched "$formattedQuery"',
        ).show(context);
      }
    } else {
      if (await hasInternetConnection()) {
        const QuimifyMessageDialog(
          title: 'Sin resultado',
        ).show(context);
      } else {
        quimifyNoInternetDialog.show(context);
      }
    }
  }

  _searchFromCompletion(String completion) async {
    if (isEmptyWithBlanks(completion)) {
      return;
    }

    startQuimifyLoading(context);

    var result = await Api().getInorganicFromCompletion(completion);

    await _processResult(result, formatInorganicFormulaOrName(completion));

    stopQuimifyLoading();
  }

  _searchFromQuery(String input) async {
    if (isEmptyWithBlanks(input)) {
      return;
    }

    startQuimifyLoading(context);

    var result = await Api().getInorganic(toDigits(input));

    await _processResult(result, input);

    stopQuimifyLoading();
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
    return WillPopScope(
      onWillPop: () async {
        // TODO in disposal method instead?
        stopQuimifyLoading();
        return true;
      },
      child: GestureDetector(
        onTap: _textFocusNode.unfocus,
        child: QuimifyScaffold(
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
            controller: context.responsiveScrollController(_scrollController),
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
