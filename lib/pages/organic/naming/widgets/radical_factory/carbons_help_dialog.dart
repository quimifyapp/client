import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class CarbonsHelpDialog extends StatelessWidget {
  const CarbonsHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Número de carbonos': [
          const Center(
            child: DialogContentText(
              text: 'Es la cantidad total de carbonos en el radical.',
            ),
          ),
          const DialogContentText(
            text: 'Ejemplos con 3 carbonos:',
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
          const SizedBox(height: 25),
          Center(
            child: Image.asset(
              'assets/images/icons/iso-radical.png',
              height: 70,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Center(
            child: DialogContentText(
              text: '(radical isopropil)',
            ),
          ),
        ],
      },
    );
  }
}
