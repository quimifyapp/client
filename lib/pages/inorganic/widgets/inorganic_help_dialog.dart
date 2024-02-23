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
              richText: 'Los compuestos inorgánicos no tienen al carbono como '
                  'elemento principal.',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplos:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'CO₂',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'ácido sulfúrico',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'NaCl',
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
              richText: 'cloruro de sodio   ➔   NaCl',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'nitrato de plata   ➔   AgNO₃',
            ),
          ),
        ],
        'Nombrar': [
          Center(
            child: DialogContentText(
              richText: 'Consiste en averiguar el nombre dada la fórmula.',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplos:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'CrO₃   ➔   óxido de cromo(VI)',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Al₂(SO₃)₃   ➔   sulfito de aluminio',
            ),
          ),
        ],
      },
    );
  }
}
