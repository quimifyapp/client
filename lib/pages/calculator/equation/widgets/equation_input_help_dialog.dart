import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class EquationInputHelpDialog extends StatelessWidget {
  const EquationInputHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Balancear reacciones': [
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
                ),
                children: const [
                  TextSpan(
                    text: 'Para balancear una reacción, escribe los ',
                  ),
                  TextSpan(
                    text: 'reactivos',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: ' encima de la flecha y los ',
                  ),
                  TextSpan(
                    text: 'productos',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: ' debajo de la flecha.',
                  ),
                ],
              ),
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
                    text: '2H₂ + O₂',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: '\n⟶\n',
                  ),
                  TextSpan(
                    text: '2H₂O',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ]
      },
    );
  }
}
