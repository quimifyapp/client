import 'package:cliente/api/results/organic_result.dart';
import 'package:cliente/pages/nomenclature/organic/widgets/result_display.dart';
import 'package:cliente/utils/loading.dart';
import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../utils/text.dart';
import '../../../constants.dart';
import '../../../widgets/dialog_popup.dart';
import '../../../widgets/page_app_bar.dart';
import '../widgets/search_bar.dart';

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
    '102.09',
    null,
    false,
  );

  Future<void> _search(String name, bool photo) async {
    if (!isEmptyWithBlanks(name)) {
      startLoading(context);

      OrganicResult? result = await Api().getOrganic(toDigits(name), photo);

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
          DialogPopup.reportableMessage(
            title: 'Sin resultado',
            details: 'No se ha encontrado:\n"$name"',
          ).show(context);
        }
      } else {
        // Client already reported an error in this case
        if (!mounted) return; // For security reasons
        DialogPopup.message(
          title: 'Sin resultado',
          details: 'No se ha encontrado:\n"$name"',
        ).show(context);
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
        child: Container(
          decoration: quimifyGradientBoxDecoration,
          child: Scaffold(
            // To avoid keyboard resizing:
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  const PageAppBar(title: 'Formular orgánico'),
                  SearchBar(
                    label: _labelText,
                    controller: _textController,
                    focusNode: _textFocusNode,
                    corrector: formatOrganicName,
                    onSubmitted: (input) => _search(input, false),
                  ),
                  Expanded(
                    child: ResultDisplay(
                      firstTitle: 'Búsqueda:',
                      firstField: _result.name!,
                      secondTitle: 'Masa molecular:',
                      secondField: '${_result.mass!} g/mol',
                      thirdTitle: 'Fórmula',
                      thirdField: formatOrganicFormula(_result.structure!),
                      imageProvider: _firstSearch
                          ? const AssetImage('assets/images/dietanoic_acid.png')
                          : NetworkImage(_result.url2D!) as ImageProvider,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
