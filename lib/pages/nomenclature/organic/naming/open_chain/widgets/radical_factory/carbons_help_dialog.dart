import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class CarbonsHelpDialog extends StatelessWidget {
  const CarbonsHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Número de carbonos',
      content: Wrap(
        runSpacing: 15,
        children: [
          const QuimifyDialogContentText(
            text: 'La cantidad total de carbonos en el radical.',
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplos con tres carbonos:',
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 25),
          Center(
            child: Image.asset(
              'assets/images/icons/propyl.png',
              height: 19,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: '(propil)',
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
            child: QuimifyDialogContentText(
              text: '(isopropil)',
            ),
          ),
        ],
      ),
      actions: [
        QuimifyDialogButton(
          onPressed: () => Navigator.pop(context),
          text: 'Entendido',
        ),
      ],
    );
  }
}
