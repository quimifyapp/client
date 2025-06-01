import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class CarbonsHelpDialog extends StatelessWidget {
  const CarbonsHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.carbonNumber: [
          Center(
            child: DialogContentText(
              richText: context.l10n.itIsTheTotalNumberOfCarbonsInTheRadical,
            ),
          ),
          DialogContentText(
            richText: context.l10n.exampleWith3Carbons,
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
          const SizedBox(height: 25),
          Center(
            child: Image.asset(
              'assets/images/icons/iso-radical.png',
              height: 70,
              color: QuimifyColors.primary(context),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.radicalIsopropyl,
            ),
          ),
        ],
      },
    );
  }
}
