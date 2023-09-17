import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/quimify_dialog_content_text.dart';

class FindingFormulaHelpDialog extends StatelessWidget {
  const FindingFormulaHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
        'Orgánica': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Los compuestos orgánicos contienen carbonos enlazados a '
                  'hidrógenos.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₃ – CH₂ – CH₃',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(text: 'ácido etanoico'),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₂ = CH – CONH₂',
            ),
          ),
        ],
        'Formular': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Consiste en averiguar la fórmula dado el nombre.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'etanol   ➔   CH₃ – CH₂(OH)',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'propadieno   ➔   CH₂ = CH = CH₂',
            ),
          ),
        ],
      },
    );
  }
}
