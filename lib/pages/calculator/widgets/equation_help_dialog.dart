import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class EquationHelpDialog extends StatelessWidget {
  const EquationHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Reacción química': [
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
                    text: 'Una reacción química tiene ',
                  ),
                  TextSpan(
                    text: 'reactivos',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: ' y ',
                  ),
                  TextSpan(
                    text: 'productos',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: '.',
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
                    text: '  ⟶  ',
                  ),
                  TextSpan(
                    text: '2H₂O',
                    style: TextStyle(color: Colors.red),
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
