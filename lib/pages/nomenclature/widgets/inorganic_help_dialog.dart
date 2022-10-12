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
            text: 'Ejemplos de fórmula:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'CO₂\nFe(OH)₃\nH₂SO₄',
            ),
          ),
          QuimifyDialogContentText(
            text: 'Ejemplos de nombre:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: QuimifyDialogContentText(
              text: 'dióxido de carbono\n'
                  'hidróxido de hierro(III)\n'
                  'ácido sulfúrico',
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
