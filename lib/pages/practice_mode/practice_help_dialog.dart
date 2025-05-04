import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class PracticeHelpDialog extends StatelessWidget {
  const PracticeHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.selectDifficulty: [
          DialogContentText(
            richText: '*${context.l10n.difficulty}:*',
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.easy,
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.medium,
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.difficult,
            ),
          ),
        ],
        context.l10n.selectCategory: [
          DialogContentText(
            richText: '*${context.l10n.categories}:*',
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.general,
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.balancingEquations,
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.inorganic,
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.organic,
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.universityChemistry,
            ),
          ),
        ],
        context.l10n.rankUp: [
          Center(
            child: DialogContentText(
              richText: '${context.l10n.rankUpDescription}',
            ),
          ),
        ],
      },
    );
  }
}
