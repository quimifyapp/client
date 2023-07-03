import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_search_bar.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/internet.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NamingAndFindingFormulaPage extends StatefulWidget {
  const NamingAndFindingFormulaPage({Key? key}) : super(key: key);

  @override
  State<NamingAndFindingFormulaPage> createState() =>
      _NamingAndFindingFormulaPageState();
}

// * NEW: Added a loading state & caching system
class _NamingAndFindingFormulaPageState
    extends State<NamingAndFindingFormulaPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  late SharedPreferences _prefs;
  bool _isLoading = true; // flag to track loading state

  //Initialize the preferences & load cached views
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadResultViewsFromCache(); // Await the cache loading
    setState(() {
      _isLoading = false; // Update the loading state
    });
  }

  String _labelText = 'NaCl, óxido de hierro...';

  // * Variable where the results will be stored
  final List<InorganicResultView> _resultViews = [];

  //Cache the views
  Future<void> _loadResultViewsFromCache() async {
    // print('Cargando vistas de resultados desde la caché');
    try {
      final String? cachedViews = _prefs.getString('cachedViews');
      if (cachedViews != null) {
        //Using Map<String, dynamic> instead of simple String for better performance & readability
        final jsonMap = jsonDecode(cachedViews) as Map<String, dynamic>;
        final List<dynamic> jsonList = jsonMap['views'];
        final List<InorganicResultView> loadedResultViews =
            jsonList.map((json) => InorganicResultView.fromJson(json)).toList();
        setState(() {
          _resultViews.clear();
          _resultViews.addAll(loadedResultViews);
        });
      }
    } catch (e) {
      print('Error loading cached views: $e');
    }

    if (_resultViews.isEmpty) {
      _addDefaultResultView();
    }
  }

  //For new users, in order to show something in the results list
  void _addDefaultResultView() {
    setState(() {
      _resultViews.clear();
      _resultViews.add(
        InorganicResultView(
          formattedQuery: 'NaCl',
          inorganicResult: InorganicResult(
            present: true,
            formula: 'NaCl',
            stockName: 'cloruro de sodio',
            systematicName: 'monocloruro de sodio',
            traditionalName: 'cloruro sódico',
            commonName: 'sal de mesa',
            molecularMass: '58.35',
            density: '2.16',
            meltingPoint: '1074.15',
            boilingPoint: '1686.15',
          ),
        ),
      );
    });
  }

  // * Save the views in the cache
  Future<void> _saveResultViewsToCache(
      List<InorganicResultView> resultViews) async {
    final List<String> serializedViews =
        resultViews.map((view) => jsonEncode(view.toJson())).toList();
    await _prefs.setStringList('cachedViews',
        serializedViews); // * cachedViews is the key in the cache
  }

  // This method is for saving the views in the cache before the widget is disposed (closed)
  @override
  void dispose() {
    _storeResultViewsInCache();
    super.dispose(); //Call dispose on the super class
  }

  void _storeResultViewsInCache() {
    try {
      final List<Map<String, dynamic>> serializedViews = _resultViews
          .map((InorganicResultView view) => view.toJson())
          .toList();
      final jsonMap = {'views': serializedViews};
      final jsonString = jsonEncode(jsonMap);
      _prefs.setString(
          'cachedViews', jsonString); // * cachedViews is the key in the cache
    } catch (e) {
      print('Error saving views to cache: $e');
    }
  }

  // Completions cache:
  static final Map<String, String> _normalizedToCompletion = {};
  static final Set<String> _completionNotFoundNormalizedInputs = {};

  void _storeCompletionInCache(String? completion, String normalizedInput) {
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

  void _processResult(String formattedQuery, InorganicResult? inorganicResult) {
    stopQuimifyLoading();

    if (inorganicResult != null) {
      if (inorganicResult.present) {
        // Search if it's already in cache
        _resultViews.removeWhere((view) =>
            removeDiacritics(view.inorganicResult.formula!.toLowerCase()) ==
            removeDiacritics(inorganicResult.formula!.toLowerCase()));

        setState(() {
          _resultViews.add(
            InorganicResultView(
              formattedQuery: formattedQuery,
              inorganicResult: inorganicResult,
            ),
          );
          _saveResultViewsToCache(_resultViews);
        });

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
        ).showIn(context);
      }
    } else {
      // Client already reported an error in this case
      hasInternetConnection().then((bool hasInternetConnection) {
        if (hasInternetConnection) {
          const QuimifyMessageDialog(
            title: 'Sin resultado',
          ).showIn(context);
        } else {
          quimifyNoInternetDialog.showIn(context);
        }
      });
    }
  }

  Future<void> _searchFromCompletion(String completion) async {
    if (isEmptyWithBlanks(completion)) {
      return;
    }

    startQuimifyLoading(context);

    InorganicResult? inorganicResult =
        await Api().getInorganicFromCompletion(completion);

    _processResult(formatInorganicFormulaOrName(completion), inorganicResult);
  }

  Future<void> _searchFromQuery(String input, bool photo) async {
    if (isEmptyWithBlanks(input)) {
      return;
    }

    startQuimifyLoading(context);

    InorganicResult? inorganicResult =
        await Api().getInorganic(toDigits(input));

    _processResult(input, inorganicResult);
  }

  void _scrollToStart() {
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
        stopQuimifyLoading();
        return true;
      },
      child: GestureDetector(
        onTap: () => _textFocusNode.unfocus(),
        child: QuimifyScaffold(
          header: Column(
            children: [
              const QuimifyPageBar(title: 'Nomenclatura inorgánica'),
              QuimifySearchBar(
                label: _labelText,
                textEditingController: _textController,
                focusNode: _textFocusNode,
                inputCorrector: formatInorganicFormulaOrName,
                onSubmitted: (input) => _searchFromQuery(input, false),
                completionCorrector: formatInorganicFormulaOrName,
                completionCallBack: _getCompletion,
                onCompletionPressed: _searchFromCompletion,
              ),
            ],
          ),
          body: _isLoading // Show loading indicator while loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
