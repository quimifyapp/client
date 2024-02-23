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
              richText: 'Consiste en averiguar el nombre dada la fórmula.',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplos:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'CH₃ – CH₂(OH)   ➔   etanol',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'CH₂ = CH = CH₂   ➔   propadieno',
            ),
          ),
        ],
      },
    );
  }
}
