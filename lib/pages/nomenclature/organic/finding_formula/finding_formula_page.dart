import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:quimify_client/pages/nomenclature/organic/widgets/organic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_search_bar.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/internet.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:flutter/material.dart';

class FindingFormulaPage extends StatefulWidget {
  const FindingFormulaPage({Key? key}) : super(key: key);

  @override
  State<FindingFormulaPage> createState() => _FindingFormulaPageState();
}

class _FindingFormulaPageState extends State<FindingFormulaPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  String _labelText = 'dietiléter, but-2-eno...';
  bool _firstSearch = true;
  OrganicResult _result = OrganicResult(
    true,
    'COOH - COOH',
    'ácido etanodioico',
    102.09,
    null,
    false,
  );

  Future<void> _search(String name, bool picture) async {
    if (!isEmptyWithBlanks(name)) {
      startLoading(context);

      OrganicResult? result =
          await Api().getOrganicByName(toDigits(name), picture);

      stopLoading();

      if (result != null) {
        if (result.present) {
          setState(() {
            _result = result;
            if (_firstSearch) {
              _firstSearch = false;
            }
          });

          // UI/UX actions:

          _labelText = name; // Sets previous input as label
          _textController.clear(); // Clears input
          _textFocusNode.unfocus(); // Hides keyboard
        } else {
          if (!mounted) return; // For security reasons
          QuimifyMessageDialog.reportable(
            title: 'Sin resultado',
            details: 'No se ha encontrado:\n"$name"',
            reportLabel: 'Formular orgánico, búsqueda de "$name"',
          ).show(context);
        }
      } else {
        // Client already reported an error in this case
        if (!mounted) return; // For security reasons
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        stopLoading();
        return true;
      },
      child: GestureDetector(
        onTap: () => _textFocusNode.unfocus(),
        child: QuimifyScaffold(
          header: Column(
            children: [
              const QuimifyPageBar(title: 'Formular orgánico'),
              QuimifySearchBar(
                label: _labelText,
                controller: _textController,
                focusNode: _textFocusNode,
                inputCorrector: formatOrganicName,
                onSubmitted: (String input) => _search(input, false),
                // Disabled:
                completionCorrector: (_) => _,
                completionCallBack: (_) async => [],
                onCompletionPressed: (_) {},
              ),
            ],
          ),
          body: OrganicResultView(
            fields: {
              if (_result.name != null) 'Búsqueda:': _result.name!,
              if (_result.mass != null)
                'Masa molecular:':
                    '${formatMolecularMass(_result.mass!)} g/mol',
              if (_result.structure != null)
                'Fórmula:': formatStructure(_result.structure!),
            },
            imageProvider: _firstSearch
                ? const AssetImage('assets/images/dietanoic-acid.png')
                : _result.url2D != null
                    ? NetworkImage(_result.url2D!) as ImageProvider
                    : null,
            quimifyReportDialog: QuimifyReportDialog(
              reportLabel: 'Formular orgánico, resultado de "${_result.name!}"',
              details: 'Resultado de:\n"${_result.name!}"',
            ),
          ),
        ),
      ),
    );
  }
}
