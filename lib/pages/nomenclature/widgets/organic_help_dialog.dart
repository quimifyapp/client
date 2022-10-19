import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class OrganicHelpDialog extends StatelessWidget {
  const OrganicHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const QuimifySlidesDialog(
      titleToContent: {
        'Orgánica': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Los compuestos orgánicos son aquellos que contienen '
                  'carbonos enlazados a hidrógenos.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
                text: 'ácido etanoico   ➔   CH₃ – COOH'),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₃ – CH₂ – CH₃   ➔   propano',
            ),
          ),
        ],
        'Formular': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Formular consiste averiguar la fórmula dado el nombre.',
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
        'Nombrar': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Nombrar consiste averiguar el nombre dada la fórmula.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₃ – CH₂(OH)   ➔   etanol',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₂ = CH = CH₂   ➔   propadieno',
            ),
          ),
        ],
      },
    );
  }
}
