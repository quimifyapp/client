import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/quimify_dialog_button.dart';

class MenuSuggestionDialog extends StatelessWidget {
  const MenuSuggestionDialog({
    Key? key,
    required this.suggestion,
    required this.label,
    required this.onPressedAgree,
    required this.onPressedDisagree,
  }) : super(key: key);

  final String suggestion;
  final String label;
  final VoidCallback onPressedAgree, onPressedDisagree;

  show(BuildContext context) async =>
      await showQuimifyDialog(context: context, dialog: this);

  _agreePressed(BuildContext context) => onPressedAgree();

  _disagreePressed(BuildContext context) {
    Navigator.of(context).pop();
    onPressedDisagree();
  }

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50;

    return QuimifyDialog(
      title: 'Un momento...',
      content: [
        Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontFamily: 'CeraPro',
              ),
              children: [
                TextSpan(text: '$suggestion '),
                TextSpan(
                  text: label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
            strutStyle: const StrutStyle(height: 1.5),
          ),
        ),
      ],
      actions: [
        QuimifyDialogButton(
          text: 'Sí, eso es',
          onPressed: () => _agreePressed(context),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          // TODO make widget
          height: buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: quimifyGradient(),
          ),
          child: Container(
            margin: EdgeInsets.all(2), // This is border width
            clipBehavior: Clip.hardEdge, // To prevent corners overflow
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10 - 2),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: SizedBox.expand(
              child: MaterialButton(
                padding: const EdgeInsets.all(0),
                splashColor: Colors.transparent,
                onPressed: () => _disagreePressed(context),
                child: Text(
                  'No, seguir buscando',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: quimifyTeal,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
