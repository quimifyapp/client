import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class OrganicNamingHelpDialog extends StatelessWidget {
  const OrganicNamingHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifySlidesDialog(
      titleToContent: {
        'Cadena abierta': [
          const Center(
            child: QuimifyDialogContentText(
              text: 'Los compuestos orgánicos de cadena abierta son los que no '
                  'forman ciclos.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: Image.asset(
              'assets/images/icons/4-ethyl-2-methylhexane.png',
              height: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: '(4-etil-2-metilhexano)',
            ),
          ),
        ],
        'Cíclico': [
          const Center(
            child: QuimifyDialogContentText(
              text: 'Los compuestos orgánicos cíclicos son aquellos con al '
                  'menos una cadena en forma de anillo.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: Image.asset(
              'assets/images/icons/phenol.png',
              height: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: '(hidroxibenceno)',
            ),
          ),
        ],
      },
    );
  }
}
