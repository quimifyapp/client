import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class FindingFormulaHelpDialog extends StatelessWidget {
  const FindingFormulaHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.organic: [
          Center(
            child: DialogContentText(
              richText:
                  context.l10n.organicCompoundsContainCarbonsBondedToHydrogens,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          const Center(
            child: DialogContentText(
              richText: 'CH₃ – CH₂ – CH₃',
            ),
          ),
          Center(
            child: DialogContentText(richText: context.l10n.ethanoicAcid),
          ),
          const Center(
            child: DialogContentText(
              richText: 'CH₂ = CH – CONH₂',
            ),
          ),
        ],
        context.l10n.formula: [
          Center(
            child: DialogContentText(
              richText:
                  context.l10n.itConsistsOfFindingOutTheFormulaGivenTheName,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          Center(
            child: DialogContentText(
              richText: '${context.l10n.ethanol}   ➔   CH₃ – CH₂(OH)',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: '${context.l10n.propadiene}   ➔   CH₂ = CH = CH₂',
            ),
          ),
        ],
      },
    );
  }
}
