import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/api/results/organic_result.dart';
import 'package:cliente/utils/loading.dart';
import 'package:cliente/widgets/help_button.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../api/api.dart';
import '../../../utils/text.dart';
import '../../../constants.dart';
import '../../../widgets/dialog_popup.dart';
import '../../../widgets/page_app_bar.dart';
import '../../../widgets/result_button.dart';
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
    'ácido dietanoico',
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
            details: 'No se ha encontrado "$name".',
          ).show(context);
        }
      } else {
        // Client already reported an error in this case
        if (!mounted) return; // For security reasons
        DialogPopup.message(
          title: 'Sin resultado',
          details: 'No se ha encontrado "$name".',
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      // To avoid rounded corners overflow:
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 30,
                          bottom: 5,
                          left: 25,
                          right: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Resultado',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                ResultButton(
                                  size: 44,
                                  color: Theme.of(context).colorScheme.onError,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  icon: Image.asset(
                                    'assets/images/icons/report.png',
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                    width: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ResultButton(
                                  size: 44,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  icon: Icon(
                                    Icons.share_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 1.5,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 25),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  ResultField(
                                      title: 'Búsqueda:', field: _result.name!),
                                  const SizedBox(height: 15),
                                  ResultField(
                                      title: 'Masa molecular:',
                                      field: '${_result.mass!} g/mol'),
                                  if (_result.formula != null) ...[
                                    const SizedBox(height: 15),
                                    ResultField(
                                      title: 'Fórmula:',
                                      field: formatOrganicFormula(
                                          _result.formula!),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                Text(
                                  'Estructura:',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                const HelpButton(),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // To avoid rounded corners overflow:
                                clipBehavior: Clip.hardEdge,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.matrix(
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? [
                                            -1, 0, 0, 0, 255, //
                                            0, -1, 0, 0, 255, //
                                            0, 0, -1, 0, 255, //
                                            0, 0, 0, 1, 0, //
                                          ]
                                        : [
                                            1, 0, 0, 0, 0, //
                                            0, 1, 0, 0, 0, //
                                            0, 0, 1, 0, 0, //
                                            0, 0, 0, 1, 0, //
                                          ],
                                  ),
                                  child: PhotoView(
                                    filterQuality: FilterQuality.high,
                                    gaplessPlayback: true,
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    minScale: 1.1,
                                    initialScale: 1.1,
                                    maxScale: 5.0,
                                    imageProvider: _firstSearch
                                        ? const AssetImage(
                                            'assets/images/dietanoic_acid.png')
                                        : NetworkImage(_result.url2D!)
                                            as ImageProvider,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
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

class ResultField extends StatelessWidget {
  const ResultField({Key? key, required this.title, required this.field})
      : super(key: key);

  final String title, field;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AutoSizeText(
            field,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
