import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class MolecularMassHelpDialog extends StatelessWidget {
  const MolecularMassHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.molecularMass: [
          Center(
            child: DialogContentText(
              richText: context.l10n
                  .theMolecularMassOfACompoundIsTheMassInGramsOfOneMolOfThatCompound,
            ),
          ),
          DialogContentText(
            richText: context.l10n.examples,
          ),
          const Center(
            child: DialogContentText(
              richText: 'CH₃ – CH₂(OH)   ➔   46.06 g/mol',
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: 'B₂O₃   ➔   69.60 g/mol',
            ),
          ),
        ],
      },
    );
  }
}
