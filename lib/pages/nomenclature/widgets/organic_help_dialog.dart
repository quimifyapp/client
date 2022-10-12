import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class OrganicHelpDialog extends StatelessWidget {
  const OrganicHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Orgánica',
      content: Wrap(
        runSpacing: 15,
        children: const [
          QuimifyDialogContentText(
            text: 'Los compuestos orgánicos son los que contienen carbonos '
                'enlazados a hidrógenos.',
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos de fórmula:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CH₃ - CH₂ - COOH\n'
                  'CH₃ - O - CHF - CH₃\n'
                  'CH₂ = CH - CH₂ - CONH₂',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos de nombre:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'ácido propanoico\n'
                  '1-fluoroetil metil éter\n'
                  'but-3-enamida',
            ),
          ),
        ],
      ),
      actions: [
        QuimifyDialogButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Entendido',
        ),
      ],
    );
  }
}
