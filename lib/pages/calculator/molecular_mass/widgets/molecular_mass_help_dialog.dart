import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class MolecularMassHelpDialog extends StatelessWidget {
  const MolecularMassHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const QuimifySlidesDialog(
      titleToContent: {
        'Concepto de mol': [
          Center(
            child: QuimifyDialogContentText(
              text: 'Un mol significa 6.022 x 10²³ cosas. Este número se '
                  'conoce como la constante de Avogadro.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'Un mol de coches son 6.022 x 10²³ coches.',
            ),
          ),
        ],
        'Átomos': [
          Center(
            child: QuimifyDialogContentText(
              text: 'La masa molecular de un átomo es la masa, en gramos, de '
                  'un mol de ese átomo.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'H (hidrógeno)   ➔   1.01 g/mol',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'O (oxígeno)   ➔   15.99 g/mol',
            ),
          ),
        ],
        'Compuestos': [
          Center(
            child: QuimifyDialogContentText(
              text: 'La masa molecular de un compuesto es la suma de las '
                  'masas de sus átomos.',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'El agua (H₂O) tiene dos átomos de hidrógeno y uno de '
                  'oxígeno en su molécula. Su masa molecular es:',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: '2 x 1.01 + 1 x 15.99 = 18.00 g/mol',
            ),
          ),
        ],
      },
    );
  }
}
