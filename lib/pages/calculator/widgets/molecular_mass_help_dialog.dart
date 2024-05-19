import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class MolecularMassHelpDialog extends StatelessWidget {
  const MolecularMassHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
        'Masa molecular': [
          Center(
            child: DialogContentText(
              richText: 'La masa molecular de un compuesto es la masa, en gramos, '
                  'de 1 mol de ese compuesto.',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplos:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'CH₃ – CH₂(OH)   ➔   46.06 g/mol',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'B₂O₃   ➔   69.60 g/mol',
            ),
          ),
        ],
      },
    );
  }
}
