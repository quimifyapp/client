import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_search_bar.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/internet.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:flutter/material.dart';

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

  String _labelText = 'NaCl, óxido de hierro...';

  final List<InorganicResultView> _results = [
    InorganicResultView(
      query: 'NaCl',
      inorganicResult: InorganicResult(
        true,
        'NaCl',
        'cloruro de sodio',
        'monocloruro de sodio',
        'cloruro sódico',
        null,
        '58.35',
        '2.16',
        '1074.15',
        '1686.15',
      ),
    ),
  ];

  Future<String?> _getCompletion(String input) =>
      Api().getInorganicCompletion(toDigits(input));

  void _processResult(String query, InorganicResult? inorganicResult) {
    stopQuimifyLoading();

    if (inorganicResult != null) {
      if (inorganicResult.present) {
        setState(
          () => _results.add(
            InorganicResultView(
              query: query,
              inorganicResult: inorganicResult,
            ),
          ),
        );

        // UI/UX actions:

        _labelText = query; // Sets previous input as label
        _textController.clear(); // Clears input
        _textFocusNode.unfocus(); // Hides keyboard
        _scrollToStart(); // Goes to the top of the page
      } else {
        QuimifyMessageDialog.reportable(
          title: 'Sin resultado',
          details: 'No se ha encontrado:\n'
              '"${formatInorganicFormulaOrName(query)}"',
          reportLabel: 'Formulación inorgánica, búsqueda de "$query"',
        ).show(context);
      }
    } else {
      // Client already reported an error in this case
      checkInternetConnection().then((bool hasInternetConnection) {
        if (hasInternetConnection) {
          const QuimifyMessageDialog(
            title: 'Sin resultado',
          ).show(context);
        } else {
          quimifyNoInternetDialog.show(context);
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

    _processResult(completion, inorganicResult);
  }

  Future<void> _searchFromQuery(String input, bool photo) async {
    if (isEmptyWithBlanks(input)) {
      return;
    }

    startQuimifyLoading(context);

    InorganicResult? inorganicResult =
        await Api().getInorganic(toDigits(input), photo);

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
              const QuimifyPageBar(title: 'Formulación inorgánica'),
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
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Wrap(
              verticalDirection: VerticalDirection.up,
              runSpacing: 25,
              children: _results,
            ),
          ),
        ),
      ),
    );
  }
}
