import 'package:cliente/api/api.dart';
import 'package:cliente/api/results/organic_result.dart';
import 'package:cliente/constants.dart';
import 'package:cliente/pages/nomenclature/organic/widgets/organic_result_view.dart';
import 'package:cliente/pages/nomenclature/widgets/search_bar.dart';
import 'package:cliente/utils/text.dart';
import 'package:cliente/widgets/dialog_popup.dart';
import 'package:cliente/widgets/loading.dart';
import 'package:cliente/widgets/page_app_bar.dart';
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
    '102.09',
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
            body: Column(
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    // To avoid rounded corners overflow:
                    clipBehavior: Clip.hardEdge,
                    child: OrganicResultView(
                      fields: {
                        if (_result.name != null) 'Búsqueda:': _result.name!,
                        if (_result.mass != null)
                          'Masa molecular:': '${_result.mass!} g/mol',
                        if (_result.structure != null)
                          'Fórmula:': formatStructure(_result.structure!),
                      },
                      imageProvider: _firstSearch
                          ? const AssetImage('assets/images/dietanoic_acid.png')
                          : NetworkImage(_result.url2D!) as ImageProvider,
                    ),
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
