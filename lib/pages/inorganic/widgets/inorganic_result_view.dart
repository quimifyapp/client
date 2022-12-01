import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_field.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_fields.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_name.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:flutter/material.dart';

class InorganicResultView extends StatefulWidget {
  const InorganicResultView({
    Key? key,
    required this.query,
    required this.inorganicResult,
  }) : super(key: key);

  final String query;
  final InorganicResult inorganicResult;

  @override
  State<InorganicResultView> createState() => _InorganicResultViewState();
}

class _InorganicResultViewState extends State<InorganicResultView> {
  late bool _isCollapsed = true;
  final AutoSizeGroup _fieldTitleAutoSizeGroup = AutoSizeGroup();

  void _pressedReportButton() {
    QuimifyReportDialog(
      details: 'Resultado de:\n'
          '"${formatInorganicFormulaOrName(widget.query)}"',
      reportLabel: 'Formulación inorgánica, resultado de "${widget.query}": '
          '(${widget.inorganicResult.formula})',
    ).show(context);
  }

  void _pressedShareButton() => quimifyComingSoonDialog.show(context);

  void _onTap() => setState(() => _isCollapsed = !_isCollapsed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Column(
        children: [
          // Head (Result of: ...):
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 15 + 2,
              bottom: 15 - 2,
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                Text(
                  'Búsqueda: ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    formatInorganicFormulaOrName(widget.query),
                    maxLines: 1,
                    minFontSize: 12,
                    stepGranularity: 0.1,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Horizontal break:
          const SizedBox(height: 2),
          // Body:
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatInorganicFormulaOrName(widget.inorganicResult.formula!),
                  style: const TextStyle(
                    color: quimifyTeal,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InorganicResultName(
                  label: 'Stock',
                  name: widget.inorganicResult.stockName,
                ),
                InorganicResultName(
                  label: 'Sistemática',
                  name: widget.inorganicResult.systematicName,
                ),
                InorganicResultName(
                  label: 'Tradicional',
                  name: widget.inorganicResult.traditionalName,
                ),
                InorganicResultName(
                  label: 'Nombre',
                  name: widget.inorganicResult.otherName,
                ),
                const SizedBox(height: 15),
                AnimatedSize(
                  duration: Duration(milliseconds: _isCollapsed ? 150 : 300),
                  alignment: Alignment.topCenter,
                  curve: Curves.easeOut,
                  child: SizedBox(
                    height: _isCollapsed ? 0 : null,
                    child: Column(
                      children: [
                        InorganicResultFields(
                          fields: [
                            InorganicResultField(
                              title: 'Masa',
                              quantity: widget.inorganicResult.molecularMass,
                              unit: 'g/mol',
                              titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                            ),
                            InorganicResultField(
                              title: 'Densidad',
                              quantity: widget.inorganicResult.density,
                              unit: 'g/cm³',
                              titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                            ),
                            InorganicResultField(
                              title: 'P. de fusión',
                              quantity: widget.inorganicResult.meltingPoint,
                              unit: 'K',
                              titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                            ),
                            InorganicResultField(
                              title: 'P. de ebullición',
                              quantity: widget.inorganicResult.boilingPoint,
                              unit: 'K',
                              titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: QuimifyIconButton(
                                height: 50,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                onPressed: _pressedReportButton,
                                icon: Image.asset(
                                  'assets/images/icons/report.png',
                                  color: Theme.of(context).colorScheme.onError,
                                  width: 18,
                                ),
                                text: Text(
                                  'Reportar',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: QuimifyIconButton(
                                height: 50,
                                onPressed: _pressedShareButton,
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
                                text: Text(
                                  'Compartir',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: RotatedBox(
                    quarterTurns: _isCollapsed ? 2 : 0,
                    child: Image.asset(
                      'assets/images/icons/narrow-arrow.png',
                      color: const Color.fromARGB(255, 189, 189, 189),
                      width: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
