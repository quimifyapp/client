import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class BalancerReactantHelpDialog extends StatelessWidget {
  const BalancerReactantHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Reactivos': [
          //Primera Página
          const Center(
            child: DialogContentText(
              richText:
                  'Los reactivos es como se le llaman a las sustancia o compuesto añadidos a un '
                  'sistema para provocar una reacción química. Se situan en el lado '
                  'izquierdo de la reacción',
            ),
          ),
          const DialogContentText(
            richText: '*Ejemplo:*',
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
                  TextSpan(
                    text: '2H + O',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: '   ➔   H₃O'),
                ],
              ),
            ),
          ),
        ],
      },
    );
  }
}
