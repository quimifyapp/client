import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class TipShapeHelpDialog extends StatelessWidget {
  const TipShapeHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Terminación': [
          const Center(
            child: DialogContentText(
              text: 'Es la forma de la punta del radical.',
            ),
          ),
          const DialogContentText(
            text: 'Terminación normal:',
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/propyl.png',
                height: 19,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              text: '(radical propil)',
            ),
          ),
        ],
      },
    );
  }
}
