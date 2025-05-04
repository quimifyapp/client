import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/contact_buttons.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class ReportSentDialog extends StatelessWidget {
  const ReportSentDialog({
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
      title: context.l10n.needHelp,
      content: [
        Center(
          child: DialogContentText(
            richText: context.l10n.needHelpDescription,
          ),
        ),
        ContactButtons(
          emailBody: userMessage,
          afterClicked: () => _exit(context),
        ),
      ],
      actions: [
        DialogButton(
          onPressed: () => _exit(context),
          text: context.l10n.understood,
        ),
      ],
    );
  }
}
