import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_negative_button.dart';

class ClassificationDialog extends StatelessWidget {
  const ClassificationDialog({
    Key? key,
    required this.richText,
    this.closeOnAgree = false,
    required this.onPressedAgree,
    required this.onPressedDisagree,
  }) : super(key: key);

  final String richText;
  final bool closeOnAgree;
  final VoidCallback onPressedAgree;
  final VoidCallback onPressedDisagree;

  show(BuildContext context) =>
      showQuimifyDialog(context: context, dialog: this);

  _agreePressed(BuildContext context) {
    if (closeOnAgree) {
      Navigator.of(context).pop();
    }

    onPressedAgree();
  }

  _disagreePressed(BuildContext context) {
    Navigator.of(context).pop();
    onPressedDisagree();
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Un momento...',
      content: [
        Center(
          child: DialogContentText(
            richText: richText,
          ),
        )
      ],
      actions: [
        DialogButton(
          text: 'Sí, eso es',
          onPressed: () => _agreePressed(context),
        ),
        const SizedBox(height: 8),
        DialogNegativeButton(
          text: 'No, seguir buscando',
          onPressed: () => _disagreePressed(context),
        ),
      ],
    );
  }
}
