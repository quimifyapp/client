import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class InorganicHelpDialog extends StatelessWidget {
  const InorganicHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const QuimifyHelpSlidesDialog(
      titleToContent: {
        'Inorgánica': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Los compuestos inorgánicos no tienen al carbono como '
                  'elemento principal.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CO₂',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'ácido sulfúrico',
            ),
          ),
        ],
        'Formular': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Consiste averiguar la fórmula dado el nombre.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'cloruro de sodio   ➔   NaCl',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'nitrato de plata   ➔   AgNO₃',
            ),
          ),
        ],
        'Nombrar': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Consiste averiguar el nombre dada la fórmula.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CrO₃   ➔   óxido de cromo(VI)',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'Al₂(SO₃)₃   ➔   sulfito de aluminio',
            ),
          ),
        ],
      },
    );
  }
}
