import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class MolecularMassHelpDialog extends StatelessWidget {
  const MolecularMassHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Concepto de mol': const [
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
        'Elementos': [
          const Center(
            child: QuimifyDialogContentText(
              text: 'La masa molecular de un átomo es la masa, en gramos, de '
                  '1 mol de ese átomo.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
                children: const [
                  TextSpan(text: 'H (hidrógeno)   ➔   '),
                  TextSpan(
                    text: '1.01',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: ' g/mol'),
                ],
              ),
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
                children: const [
                  TextSpan(text: 'O (oxígeno)   ➔   '),
                  TextSpan(
                    text: '15.99',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(text: ' g/mol'),
                ],
              ),
            ),
          ),
        ],
        'Masa molecular': [
          const Center(
            child: QuimifyDialogContentText(
              text: 'La masa molecular de un compuesto es la suma de las '
                  'masas de sus átomos.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'El H₂O (agua) tiene 2 átomos de hidrógeno y 1 de '
                  'oxígeno en su molécula. Su masa molecular es:',
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
                children: const [
                  TextSpan(text: '2 x '),
                  TextSpan(
                    text: '1.01',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: ' + 1 x '),
                  TextSpan(
                    text: '15.99',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(text: ' = 18.00 g/mol'),
                ],
              ),
            ),
          ),
        ],
      },
    );
  }
}
