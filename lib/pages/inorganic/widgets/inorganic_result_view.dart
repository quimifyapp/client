import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/results/inorganic_result.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_field.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_fields.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_name.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/report/report_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

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
      details: '${context.l10n.resultOf}\n"${widget.formattedQuery}"',
      reportContext: context.l10n.inorganicNamingAndFindingFormula,
      reportDetails: '${context.l10n.resultOf} "${widget.formattedQuery}": '
          '${widget.result}',
    ).show(context);
  }

  _pressedShareButton() => comingSoonDialog(context).show(context);

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
              color: QuimifyColors.foreground(context),
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
                  '${context.l10n.search}: ',
                  style: TextStyle(
                    color: QuimifyColors.secondary(context),
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
                      color: QuimifyColors.primary(context),
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
              color: QuimifyColors.foreground(context),
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
                  style: TextStyle(
                    color: QuimifyColors.teal(),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InorganicResultName(
                  label: context.l10n.stock,
                  name: widget.result.stockName,
                ),
                InorganicResultName(
                  label: context.l10n.systematic,
                  name: widget.result.systematicName,
                ),
                InorganicResultName(
                  label: context.l10n.traditional,
                  name: widget.result.traditionalName,
                ),
                InorganicResultName(
                  label: context.l10n.common,
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
                                title: context.l10n.molecularMass,
                                quantity: widget.result.molecularMass,
                                unit: 'g/mol',
                                titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                              ),
                            if (widget.result.density != null)
                              InorganicResultField(
                                title: context.l10n.density,
                                quantity: widget.result.density,
                                unit: 'g/cm³',
                                titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                              ),
                            if (widget.result.meltingPoint != null)
                              InorganicResultField(
                                title: context.l10n.meltingPoint,
                                quantity: widget.result.meltingPoint,
                                unit: 'K',
                                titleAutoSizeGroup: _fieldTitleAutoSizeGroup,
                              ),
                            if (widget.result.boilingPoint != null)
                              InorganicResultField(
                                title: context.l10n.boilingPoint,
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
                                backgroundColor:
                                    QuimifyColors.blueBackground(context),
                                icon: Icon(
                                  Icons.share_outlined,
                                  color: QuimifyColors.onBlueText(context),
                                  size: 18,
                                ),
                                text: Text(
                                  context.l10n.share,
                                  style: TextStyle(
                                    color: QuimifyColors.onBlueText(context),
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
                                    QuimifyColors.redBackground(context),
                                onPressed: _pressedReportButton,
                                icon: Image.asset(
                                  'assets/images/icons/report.png',
                                  color: QuimifyColors.onRedText(context),
                                  width: 18,
                                ),
                                text: Text(
                                  context.l10n.report,
                                  style: TextStyle(
                                    color: QuimifyColors.onRedText(context),
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
