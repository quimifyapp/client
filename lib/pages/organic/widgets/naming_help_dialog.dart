import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class NamingHelpDialog extends StatelessWidget {
  const NamingHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.naming: [
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
              richText: 'CH₃ – CH₂(OH)   ➔   ${context.l10n.ethanol}',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'CH₂ = CH = CH₂   ➔   ${context.l10n.propadiene}',
            ),
          ),
        ],
      },
    );
  }
}
