import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class NamingHelpDialog extends StatelessWidget {
  const NamingHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
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
              text: 'CH₃ – CH₂(OH)   ➔   etanol',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₂ = CH = CH₂   ➔   propadieno',
            ),
          ),
        ],
      },
    );
  }
}
