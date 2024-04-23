import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class BalancerHelpDialog extends StatelessWidget {
  const BalancerHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Reactivos': const [ //Primera Página
          Center(
            child: DialogContentText(
              richText: 'Un mol significa 6.022 x 10²³ cosas. Este número se '
                  'conoce como la constante de Avogadro.',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplo:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'Un mol de coches son 6.022 x 10²³ coches.',
            ),
          ),
        ],
        'Productos': [ //Segunda Página
          const Center(
            child: DialogContentText(
              richText: 'La masa molecular de un átomo es la masa, en gramos, de '
                  '1 mol de ese átomo.',
            ),
          ),
          const DialogContentText(
            richText: '*Ejemplos:*',
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
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
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
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
        'Coeficientes': [ //Tercera Página
          const Center(
            child: DialogContentText(
              richText: 'La masa molecular de un compuesto es la suma de las '
                  'masas de sus átomos.',
            ),
          ),
          const DialogContentText(
            richText: '*Ejemplo:*',
          ),
          const Center(
            child: DialogContentText(
              richText: 'El H₂O (agua) tiene 2 átomos de hidrógeno y 1 de '
                  'oxígeno en su molécula. Su masa molecular es:',
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
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
