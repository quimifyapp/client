import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/quimify_contact_buttons.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/quimify_dialog_content_text.dart';

class ThanksDialog extends StatelessWidget {
  const ThanksDialog({
    Key? key,
    this.userMessage,
  }) : super(key: key);

  final String? userMessage;

  show(BuildContext context) async =>
      await showQuimifyDialog(context: context, closable: true, dialog: this);

  _exit(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: '¿Necesitas ayuda?',
      content: [
        const Center(
          child: QuimifyDialogContentText(
            text: 'Chatea con nosotros y solucionaremos tus dudas al momento.',
          ),
        ),
        QuimifyContactButtons(
          emailBody: userMessage,
          afterClicked: () => _exit(context),
        ),
      ],
      actions: [
        QuimifyDialogButton(
          onPressed: () => _exit(context),
          text: 'Entendido',
        ),
      ],
    );
  }
}
