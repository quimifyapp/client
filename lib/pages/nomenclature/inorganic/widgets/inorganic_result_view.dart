import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/pages/nomenclature/inorganic/widgets/inorganic_result_field.dart';
import 'package:quimify_client/pages/nomenclature/inorganic/widgets/inorganic_result_fields.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:flutter/material.dart';

class InorganicResultView extends StatefulWidget {
  const InorganicResultView(
      {Key? key, required this.query, required this.inorganicResult})
      : super(key: key);

  final String query;
  final InorganicResult inorganicResult;

  @override
  State<InorganicResultView> createState() => _InorganicResultViewState();
}

class _InorganicResultViewState extends State<InorganicResultView> {
  final AutoSizeGroup _quantityTitleAutoSizeGroup = AutoSizeGroup();

  late bool _isCollapsed = true;
  late List<InorganicResultField> fields;

  void _pressedReportButton() {
    QuimifyReportDialog(
      details: 'Resultado de:\n"${widget.query}"',
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
          // Head: (Result of: ...)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 17,
              bottom: 13,
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
                    maxLines: 1,
                    minFontSize: 12,
                    stepGranularity: 0.1,
                    widget.query,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Separator:
          const SizedBox(height: 2),
          // Body:,
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 15,
              left: 20,
              right: 20,
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    toSubscripts(widget.inorganicResult.formula!),
                    style: const TextStyle(
                      color: quimifyTeal,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.inorganicResult.name!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (widget.inorganicResult.alternativeName != null) ...[
                  const SizedBox(height: 2.5),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'o ${widget.inorganicResult.alternativeName!}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
                AnimatedSize(
                  duration: Duration(milliseconds: _isCollapsed ? 150 : 300),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: _isCollapsed ? 0 : null,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        InorganicResultFields(
                          fields: [
                            if (widget.inorganicResult.molecularMass != null)
                              InorganicResultField(
                                title: 'Masa',
                                quantity: formatMolecularMass(
                                    widget.inorganicResult.molecularMass!),
                                unit: 'g/mol',
                                titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
                              ),
                            if (widget.inorganicResult.density != null)
                              InorganicResultField(
                                title: 'Densidad',
                                quantity: widget.inorganicResult.density!,
                                unit: 'g/cm³',
                                titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
                              ),
                            if (widget.inorganicResult.meltingPoint != null)
                              InorganicResultField(
                                title: 'P. de fusión',
                                quantity: widget.inorganicResult.meltingPoint!,
                                unit: 'K',
                                titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
                              ),
                            if (widget.inorganicResult.boilingPoint != null)
                              InorganicResultField(
                                title: 'P. de ebullición',
                                quantity: widget.inorganicResult.boilingPoint!,
                                unit: 'K',
                                titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
