import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/classification.dart';
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
import 'package:quimify_client/pages/widgets/dialogs/suggestions/classification_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/storage/history/history.dart';
import 'package:quimify_client/text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

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

  String _labelText = '';
  OrganicResult _result = OrganicResult(
      true,
      null,
      null,
      'COOH - COOH',
      'ácido etanodioico',
      90.01,
      null,
      // There's already a pre-loaded 2D image
      'https://pubchem.ncbi.nlm.nih.gov/compound/'
          '971#section=3D-Conformer&fullscreen=true');

  Map<Classification, String> _classificationToMessage = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _labelText = context.l10n.diethylEtherBut2Ene;

    _classificationToMessage = {
      Classification.inorganicFormula:
          context.l10n.itLooksLikeYouAreTryingToSolveAnInOrganicCompoundFormula,
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
  }

  _processClassification(Classification classification, String formattedQuery,
      VoidCallback onPressedDisagree) {
    if (classification == Classification.nomenclatureProblem) {
      MessageDialog(
        title: context.l10n.youAreAlmostThere,
        details: context.l10n.onlyEnterTheFormulaOrNameYouWantToSolve,
        onButtonPressed: () => _textFocusNode.requestFocus(),
      ).show(context);
      return;
    }

    ClassificationDialog(
      classification: classification,
      formattedQuery: formattedQuery,
      richText: _classificationToMessage[classification]!,
      onPressedDisagree: onPressedDisagree,
    ).show(context);
  }

  _showNotFoundDialog(String formattedQuery) {
    MessageDialog.reportable(
      title: context.l10n.noResult,
      details: '${context.l10n.notFound}:\n"$formattedQuery"',
      reportContext: 'Organic finding formula',
      reportDetails: 'Searched "$formattedQuery"',
    ).show(context);
  }

  _processNotFound(OrganicResult? result, String formattedQuery) async {
    if (result == null) {
      await hasInternetConnection()
          ? MessageDialog(title: context.l10n.noResult).show(context)
          : noInternetDialog(context).show(context);

      return;
    }

    if (result.classification == null) {
      _showNotFoundDialog(formattedQuery);
      return;
    }

    _processClassification(
      result.classification!,
      formattedQuery,
      () => _showNotFoundDialog(formattedQuery),
    );
  }

  _displayResult(OrganicResult result, String formattedQuery) {
    setState(() {
      _result = result;
      if (_firstSearch) {
        _firstSearch = false;
      }
    });

    History().saveOrganicFormula(result);

    // UI/UX actions:

    _labelText = formattedQuery; // Sets previous input as label
    _textController.clear(); // Clears input
    _textFocusNode.unfocus(); // Hides keyboard
    _scrollToStart(); // Goes to the top of the page
  }

  _processResult(OrganicResult? result, String formattedQuery) {
    if (result == null || !result.found) {
      _processNotFound(result, formattedQuery);
      return;
    }

    if (result.classification == null) {
      Ads().showInterstitial();
      _displayResult(result, formattedQuery);
    } else {
      _processClassification(
        result.classification!,
        formattedQuery,
        () => _displayResult(result, formattedQuery),
      );
    }
  }

  _search(String formattedQuery) async {
    if (isEmptyWithBlanks(formattedQuery)) {
      return;
    }

    showLoadingIndicator(context);

    var result = await Api().getOrganicFromName(toDigits(formattedQuery));

    if (result != null && result.found) {
      Ads().showInterstitial();
    }

    await _processResult(result, formattedQuery);

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
                        context.l10n.search,
                        e.name,
                      ),
                      if (e.structure != null)
                        HistoryField(
                          context.l10n.formula,
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
              QuimifyPageBar(title: context.l10n.formulateOrganic),
              QuimifySearchBar(
                isOrganic: true,

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
              if (_result.name != null) context.l10n.search: _result.name!,
              if (_result.structure != null)
                context.l10n.formula: formatStructure(_result.structure!),
              if (_result.molecularMass != null)
                context.l10n.molecularMass:
                    '${formatMolecularMass(_result.molecularMass!)} g/mol',
            },
            imageProvider: _firstSearch
                ? const AssetImage('assets/images/dietanoic-acid.png')
                : _result.url2D != null
                    ? NetworkImage(_result.url2D!) as ImageProvider
                    : null,
            url3D: _result.url3D,
            onHistoryPressed: (resultPageContext) => _showHistory(),
            reportDialog: ReportDialog(
              details: '${context.l10n.resultOf}\n"${_result.name!}"',
              reportContext: 'Organic finding formula',
              reportDetails: 'Result of "${_result.name!}": $_result',
            ),
          ),
        ),
      ),
    );
  }
}
