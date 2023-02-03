import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_contact_buttons.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class QuimifyThanksDialog extends StatelessWidget {
  const QuimifyThanksDialog({
    Key? key,
    required this.reportLabel,
    required this.reportDetails,
  }) : super(key: key);

  final String reportLabel;
  final String? reportDetails;

  Future<void> showIn(BuildContext context) async =>
      await showQuimifyDialog(context: context, closable: true, dialog: this);

  void _exit(BuildContext context) => Navigator.of(context).pop();

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
          emailBody: '$reportLabel\n'
              '${reportDetails != null ? '$reportDetails\n\n' : '\n'}',
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
