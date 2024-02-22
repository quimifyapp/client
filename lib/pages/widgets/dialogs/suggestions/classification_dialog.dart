import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_negative_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class ClassificationDialog extends StatelessWidget {
  const ClassificationDialog({
    Key? key,
    required this.firstText,
    required this.secondBoldText,
    this.closeOnAgree = false,
    required this.onPressedAgree,
    required this.onPressedDisagree,
  }) : super(key: key);

  final String firstText;
  final String secondBoldText;
  final bool closeOnAgree;
  final VoidCallback onPressedAgree, onPressedDisagree;

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
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: QuimifyColors.primary(context),
                fontSize: 16,
                fontFamily: 'CeraPro',
              ),
              children: [
                TextSpan(text: '$firstText '),
                TextSpan(
                  text: secondBoldText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
            strutStyle: const StrutStyle(height: 1.5),
          ),
        ),
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
