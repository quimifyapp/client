import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class OrganicHelpDialog extends StatelessWidget {
  const OrganicHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifySlidesDialog(
      titleToContent: {
        'Orgánica': Wrap(
          runSpacing: 15,
          children: const [
            QuimifyDialogContentText(
              text: 'Los compuestos orgánicos son los que contienen carbonos '
                  'enlazados a hidrógenos.',
            ),
            QuimifyDialogContentText(
              text: 'Ejemplos de fórmula:',
              fontWeight: FontWeight.bold,
            ),
            Center(
              child: QuimifyDialogContentText(
                text: 'CH₃ - CH₂ - COOH\n'
                    'CH₂ = CH - CH₂ - CONH₂',
              ),
            ),
            QuimifyDialogContentText(
              text: 'Ejemplos de nombre:',
              fontWeight: FontWeight.bold,
            ),
            Center(
              child: QuimifyDialogContentText(
                text: 'ácido propanoico\n'
                    'but-3-enamida',
              ),
            ),
          ],
        ),
        'Formular': Wrap(
          runSpacing: 15,
          children: const [
            QuimifyDialogContentText(
              text: 'Formular consiste averiguar la fórmula dado el nombre.',
            ),
            QuimifyDialogContentText(
              text: 'Ejemplos:',
              fontWeight: FontWeight.bold,
            ),
            Center(
              child: QuimifyDialogContentText(
                text: 'etanol   ➔   CH₃ - CH₂(OH)\n'
                    'propadieno   ➔   CH₂ = CH = CH₂',
              ),
            ),
          ],
        ),
        'Nombrar': Wrap(
          runSpacing: 15,
          children: const [
            QuimifyDialogContentText(
              text: 'Nombrar consiste averiguar el nombre dada la fórmula.',
            ),
            QuimifyDialogContentText(
              text: 'Ejemplos:',
              fontWeight: FontWeight.bold,
            ),
            Center(
              child: QuimifyDialogContentText(
                text: 'CH₃ - CH₂(OH)   ➔   etanol\n'
                    'CH₂ = CH = CH₂   ➔   propadieno',
              ),
            ),
          ],
        ),
      },
    );
  }
}
