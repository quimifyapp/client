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
              richText: 'Los compuestos orgánicos contienen carbonos enlazados a '
                  'hidrógenos.',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplos:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'CH₃ – CH₂ – CH₃',
            ),
          ),
          Center(
            child: DialogContentText(richText: 'ácido etanoico'),
          ),
          Center(
            child: DialogContentText(
              richText: 'CH₂ = CH – CONH₂',
            ),
          ),
        ],
        'Formular': [
          Center(
            child: DialogContentText(
              richText: 'Consiste en averiguar la fórmula dado el nombre.',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplos:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'etanol   ➔   CH₃ – CH₂(OH)',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'propadieno   ➔   CH₂ = CH = CH₂',
            ),
          ),
        ],
      },
    );
  }
}
