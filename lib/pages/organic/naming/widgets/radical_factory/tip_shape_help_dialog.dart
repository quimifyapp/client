import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class TipShapeHelpDialog extends StatelessWidget {
  const TipShapeHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.termination: [
          Center(
            child: DialogContentText(
              richText: context.l10n.itIsTheShapeOfTheTipOfTheRadical,
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.normalTermination,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/propyl.png',
                height: 19,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.radicalPropyl,
            ),
          ),
        ],
      },
    );
  }
}
