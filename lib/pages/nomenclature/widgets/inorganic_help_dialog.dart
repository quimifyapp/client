import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class InorganicHelpDialog extends StatelessWidget {
  const InorganicHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Inorgánica',
      content: Wrap(
        runSpacing: 15,
        children: const [
          QuimifyDialogContentText(
            text: 'Los compuestos inorgánicos son los que no tienen al carbono '
                'como elemento principal.',
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'ácido sulfúrico   ➔   H₂SO₄',
            ),
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CO₂   ➔   dióxido de carbono',
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
