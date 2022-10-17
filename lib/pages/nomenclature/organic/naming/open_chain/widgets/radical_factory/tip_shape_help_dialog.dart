import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class TipShapeHelpDialog extends StatelessWidget {
  const TipShapeHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Terminación',
      content: [
        const Center(
          child: QuimifyDialogContentText(
            text: 'Es la forma de la punta del radical.',
          ),
        ),
        const QuimifyDialogContentText(
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
          child: QuimifyDialogContentText(
            text: '(radical propil)',
          ),
        ),
      ],
      actions: [
        QuimifyDialogButton(
          onPressed: () => Navigator.pop(context),
          text: 'Entendido',
        ),
      ],
    );
  }
}
