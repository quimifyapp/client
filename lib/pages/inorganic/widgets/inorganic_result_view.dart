import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_field.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_fields.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_name.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/report_dialog.dart';
import 'package:quimify_client/utils/text.dart';

class InorganicResultView extends StatefulWidget {
  const InorganicResultView({
    Key? key,
    required this.formattedQuery,
    required this.result,
  }) : super(key: key);

  final String formattedQuery;
  final InorganicResult result;

  @override
  State<InorganicResultView> createState() => _InorganicResultViewState();
}

class _InorganicResultViewState extends State<InorganicResultView> {
  late bool _isCollapsed = true;
  final AutoSizeGroup _fieldTitleAutoSizeGroup = AutoSizeGroup();

  _pressedReportButton() {
    ReportDialog(
      details: 'Resultado de\n"${widget.formattedQuery}"',
      reportContext: 'Inorganic naming and finding formula',
      reportDetails: 'Result of "${widget.formattedQuery}": '
          '${widget.result}',
    ).show(context);
  }

  _pressedShareButton() => quimifyComingSoonDialog.show(context);

  _tappedBox() => setState(() => _isCollapsed = !_isCollapsed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tappedBox,
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
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    formatInorganicFormulaOrName(widget.formattedQuery),
                    maxLines: 1,
                    minFontSize: 12,
                    stepGranularity: 0.1,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
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
                  formatInorganicFormulaOrName(widget.result.formula!),
                  style: const TextStyle(
                    color: quimifyTeal,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InorganicResultName(
                  label: 'Stock',
                  name: widget.result.stockName,
                ),
                InorganicResultName(
                  label: 'Sistemática',
                  name: widget.result.systematicName,
                ),
                InorganicResultName(
                  label: 'Tradicional',
                  name: widget.result.traditionalName,
                ),
                InorganicResultName(
                  label: 'Nombre común',
                  name: widget.result.commonName,
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
                            if (widget.result.molecularMass != null)
                              InorganicResultField(
                                title: 'Masa molecular',
                                quantity: widget.result.molecularMass,
                                unit: 'g/mol',
                                titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                              ),
                            if (widget.result.density != null)
                              InorganicResultField(
                                title: 'Densidad',
                                quantity: widget.result.density,
                                unit: 'g/cm³',
                                titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                              ),
                            if (widget.result.meltingPoint != null)
                              InorganicResultField(
                                title: 'P. de fusión',
                                quantity: widget.result.meltingPoint,
                                unit: 'K',
                                titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                              ),
                            if (widget.result.boilingPoint != null)
                              InorganicResultField(
                                title: 'P. de ebullición',
                                quantity: widget.result.boilingPoint,
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
                            const SizedBox(width: 15),
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
