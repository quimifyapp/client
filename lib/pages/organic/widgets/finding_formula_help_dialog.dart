import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class FindingFormulaHelpDialog extends StatelessWidget {
  const FindingFormulaHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
        'Orgánica': [
          Center(
            child: DialogContentText(
              text: 'Los compuestos orgánicos contienen carbonos enlazados a '
                  'hidrógenos.',
            ),
          ),
          DialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: DialogContentText(
              text: 'CH₃ – CH₂ – CH₃',
            ),
          ),
          Center(
            child: DialogContentText(text: 'ácido etanoico'),
          ),
          Center(
            child: DialogContentText(
              text: 'CH₂ = CH – CONH₂',
            ),
          ),
        ],
        'Formular': [
          Center(
            child: DialogContentText(
              text: 'Consiste en averiguar la fórmula dado el nombre.',
            ),
          ),
          DialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: DialogContentText(
              text: 'etanol   ➔   CH₃ – CH₂(OH)',
            ),
          ),
          Center(
            child: DialogContentText(
              text: 'propadieno   ➔   CH₂ = CH = CH₂',
            ),
          ),
        ],
      },
    );
  }
}
