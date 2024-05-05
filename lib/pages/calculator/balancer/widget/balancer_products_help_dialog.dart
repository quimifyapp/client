import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class BalancerProductHelpDialog extends StatelessWidget {
  const BalancerProductHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Productos': [
          //Primera Página
          const Center(
            child: DialogContentText(
              richText: 'Los productos es como se le llaman a las sustancias o '
                  'compuestos obtenidas luego de ocurrir una reacción química.'
                  ' Se situan en el lado derecho de la reacción',
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
                  ),
                  TextSpan(
                    text: '   ➔   H₃O',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      },
    );
  }
}
