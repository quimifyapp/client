import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/quimify_dialog_content_text.dart';

class CalculatorHelpDialog extends StatelessWidget {
  const CalculatorHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
        'Masa molecular': [
          Center(
            child: QuimifyDialogContentText(
              text: 'La masa molecular de un compuesto es la masa, en gramos, '
                  'de 1 mol de ese compuesto.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₃ – CH₂(OH)   ➔   46.06 g/mol',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'B₂O₃   ➔   69.60 g/mol',
            ),
          ),
        ],
      },
    );
  }
}
