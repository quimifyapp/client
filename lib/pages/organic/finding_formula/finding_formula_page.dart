import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/organic_result.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/history_field.dart';
import 'package:quimify_client/pages/history/history_page.dart';
import 'package:quimify_client/pages/organic/widgets/organic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_search_bar.dart';
import 'package:quimify_client/pages/widgets/dialogs/loading_indicator.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/report/report_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/storage/history/history.dart';
import 'package:quimify_client/text.dart';

class FindingFormulaPage extends StatefulWidget {
  const FindingFormulaPage({Key? key}) : super(key: key);

  @override
  State<FindingFormulaPage> createState() => _FindingFormulaPageState();
}

class _FindingFormulaPageState extends State<FindingFormulaPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  bool _argumentRead = false;
  bool _firstSearch = true;

  String _labelText = 'dietiléter, but-2-eno...';
  OrganicResult _result = OrganicResult(
    true,
    'COOH - COOH',
    'ácido etanodioico',
    90.01,
    null,
  );

  _search(String name) async {
    if (isEmptyWithBlanks(name)) {
      return;
    }

    showLoadingIndicator(context);

    OrganicResult? result = await Api().getOrganicFromName(toDigits(name));

    if (result != null) {
      if (result.found) {
        Ads().showInterstitial();

        setState(() {
          _result = result;
          if (_firstSearch) {
            _firstSearch = false;
          }
        });

        History().saveOrganicFormula(result);

        // UI/UX actions:

        _labelText = name; // Sets previous input as label
        _textController.clear(); // Clears input
        _textFocusNode.unfocus(); // Hides keyboard
        _scrollToStart(); // Goes to the top of the page
      } else {
        if (!mounted) return; // For security reasons
        MessageDialog.reportable(
          title: 'Sin resultado',
          details: 'No se ha encontrado:\n"$name"',
          reportContext: 'Organic finding formula',
          reportDetails: 'Searched "$name"',
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
          onStartPressed: () => _textFocusNode.requestFocus(),
          entries: History()
              .getOrganicFormulas()
              .map((e) => HistoryEntry(
                    query: e.name,
                    fields: [
                      HistoryField(
                        'Búsqueda',
                        e.name,
                      ),
                      if (e.structure != null)
                        HistoryField(
                          'Fórmula',
                          formatStructure(e.structure!),
                        )
                    ],
                  ))
              .toList(),
          onEntryPressed: (name) => _search(name),
        ),
      ),
    );
  }

  // Interface:

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
        onTap: () => _textFocusNode.unfocus(),
        child: QuimifyScaffold(
          bannerAdName: runtimeType.toString(),
          header: Column(
            children: [
              const QuimifyPageBar(title: 'Formular orgánicos'),
              QuimifySearchBar(
                label: _labelText,
                textEditingController: _textController,
                focusNode: _textFocusNode,
                inputCorrector: formatOrganicName,
                onSubmitted: (String input) => _search(input),
                // Disabled:
                completionCorrector: (_) => _,
                completionCallBack: (_) async => null,
                onCompletionPressed: (_) {},
              ),
            ],
          ),
          body: OrganicResultView(
            scrollController: _scrollController,
            fields: {
              if (_result.name != null) 'Búsqueda': _result.name!,
              if (_result.molecularMass != null)
                'Masa molecular':
                    '${formatMolecularMass(_result.molecularMass!)} g/mol',
              if (_result.structure != null)
                'Fórmula': formatStructure(_result.structure!),
            },
            imageProvider: _firstSearch
                ? const AssetImage('assets/images/dietanoic-acid.png')
                : _result.url2D != null
                    ? NetworkImage(_result.url2D!) as ImageProvider
                    : null,
            onHistoryPressed: (resultPageContext) => _showHistory(),
            reportDialog: ReportDialog(
              details: 'Resultado de\n"${_result.name!}"',
              reportContext: 'Organic finding formula',
              reportDetails: 'Result of "${_result.name!}": $_result',
            ),
          ),
        ),
      ),
    );
  }
}
