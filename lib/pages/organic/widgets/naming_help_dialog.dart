import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class NamingHelpDialog extends StatelessWidget {
  const NamingHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
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
              text: 'CH₃ – CH₂(OH)   ➔   etanol',
            ),
          ),
          Center(
            child: DialogContentText(
              text: 'CH₂ = CH = CH₂   ➔   propadieno',
            ),
          ),
        ],
      },
    );
  }
}
