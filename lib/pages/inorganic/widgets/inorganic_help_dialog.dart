import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class InorganicHelpDialog extends StatelessWidget {
  const InorganicHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
        'Inorgánica': [
          Center(
            child: DialogContentText(
              text: 'Los compuestos inorgánicos no tienen al carbono como '
                  'elemento principal.',
            ),
          ),
          DialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: DialogContentText(
              text: 'CO₂',
            ),
          ),
          Center(
            child: DialogContentText(
              text: 'ácido sulfúrico',
            ),
          ),
          Center(
            child: DialogContentText(
              text: 'NaCl',
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
              text: 'cloruro de sodio   ➔   NaCl',
            ),
          ),
          Center(
            child: DialogContentText(
              text: 'nitrato de plata   ➔   AgNO₃',
            ),
          ),
        ],
        'Nombrar': [
          Center(
            child: DialogContentText(
              text: 'Consiste en averiguar el nombre dada la fórmula.',
            ),
          ),
          DialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: DialogContentText(
              text: 'CrO₃   ➔   óxido de cromo(VI)',
            ),
          ),
          Center(
            child: DialogContentText(
              text: 'Al₂(SO₃)₃   ➔   sulfito de aluminio',
            ),
          ),
        ],
      },
    );
  }
}
