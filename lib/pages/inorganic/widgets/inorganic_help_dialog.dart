import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class InorganicHelpDialog extends StatelessWidget {
  const InorganicHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.inorganic: [
          Center(
            child: DialogContentText(
              richText: context
                  .l10n.inorganicCompoundsDoNotHaveCarbonAsTheirMainElement,
            ),
          ),
          DialogContentText(
            richText: context.l10n.examples,
          ),
          const Center(
            child: DialogContentText(
              richText: 'CO₂',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.sulfuricAcid,
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: 'NaCl',
            ),
          ),
        ],
        context.l10n.writingFormulas: [
          Center(
            child: DialogContentText(
              richText:
                  context.l10n.itConsistsOfFindingOutTheFormulaGivenTheName,
            ),
          ),
          DialogContentText(
            richText: context.l10n.examples,
          ),
          Center(
            child: DialogContentText(
              richText: '${context.l10n.sodiumChloride}   ➔   NaCl',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: '${context.l10n.silverNitrate}   ➔   AgNO₃',
            ),
          ),
        ],
        context.l10n.writingNames: [
          Center(
            child: DialogContentText(
              richText:
                  context.l10n.itConsistsOfFindingOutTheNameGivenTheFormula,
            ),
          ),
          DialogContentText(
            richText: context.l10n.examples,
          ),
          Center(
            child: DialogContentText(
              richText: 'CrO₃   ➔   ${context.l10n.chromiumVIoxide}',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Al₂(SO₃)₃   ➔   ${context.l10n.aluminumSulfite}',
            ),
          ),
        ],
      },
    );
  }
}
