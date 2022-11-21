import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class CalculatorHelpDialog extends StatelessWidget {
  const CalculatorHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Masa molecular',
      content: const [
        Center(
          child: QuimifyDialogContentText(
            text: 'La masa molecular de un compuesto es la masa, en gramos, '
                'de un mol de ese compuesto.',
          ),
        ),
        QuimifyDialogContentText(
          text: 'Ejemplos:',
          fontWeight: FontWeight.bold,
        ),
        Center(
          child: QuimifyDialogContentText(
            text: 'CH₃ – CH₂(OH)   ➔   46.06 g/mol',
          ),
        ),
        Center(
          child: QuimifyDialogContentText(
            text: 'B₂O₃   ➔   69.60 g/mol',
          ),
        ),
      ],
      actions: [
        QuimifyDialogButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Entendido',
        ),
      ],
    );
  }
}
