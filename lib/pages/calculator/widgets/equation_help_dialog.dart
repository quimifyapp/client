import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class EquationHelpDialog extends StatelessWidget {
  const EquationHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.chemicalReaction: [
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
                    text: context.l10n.aChemicalReactionHas,
                  ),
                  TextSpan(
                    text: context.l10n.reactants,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: context.l10n.and,
                  ),
                  TextSpan(
                    text: context.l10n.products,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const TextSpan(
                    text: '.',
                  ),
                ],
              ),
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
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
                    text: '  ⟶  ',
                  ),
                  TextSpan(
                    text: '2H₂O',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      },
    );
  }
}
