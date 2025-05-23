import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class EquationInputHelpDialog extends StatelessWidget {
  const EquationInputHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.balanceReactions: [
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
                ),
                children: [
                  TextSpan(
                    text: context.l10n.toBalanceAReactionWriteThe,
                  ),
                  TextSpan(
                    text: context.l10n.reagents,
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: ' ${context.l10n.aboveTheArrowAndThe} ',
                  ),
                  TextSpan(
                    text: context.l10n.products,
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: ' ${context.l10n.belowTheArrow}',
                  ),
                ],
              ),
            ),
          ),
          DialogContentText(
            richText: '*${context.l10n.example}:*',
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
                ),
                children: const [
                  TextSpan(
                    text: '2H₂ + O₂',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: '\n⟶\n',
                  ),
                  TextSpan(
                    text: '2H₂O',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ]
      },
    );
  }
}
