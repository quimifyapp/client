import 'package:flutter/material.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/hydrogenate_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/undo_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class NamingHelpDialog extends StatelessWidget {
  const NamingHelpDialog({
    Key? key,
    required this.buttonHeight,
  }) : super(key: key);

  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    BoxDecoration exampleButtonBorder = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        width: 1,
        color: QuimifyColors.secondary(context),
        strokeAlign: BorderSide.strokeAlignOutside, // So size doesn't change
      ),
    );

    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.substituents: [
          Container(
            decoration: exampleButtonBorder,
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: QuimifyColors.background(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/icons/single-bond.png',
                    color: QuimifyColors.primary(context),
                    width: 30,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'H',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  context.l10n.capitalHydrogen,
                  style: TextStyle(
                    color: QuimifyColors.teal(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.add,
                  color: QuimifyColors.teal(),
                  size: 22,
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context
                  .l10n.theListWillShowTheProductsYouCanUseToPrepareCarbon,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: DialogContentText(
              richText: context.l10n.example,
            ),
          ),
          Center(
            child: Text(
              'CH₃ –',
              style: TextStyle(
                color: QuimifyColors.primary(context),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.carbonatedWithThreeHydrogens,
            ),
          ),
        ],
        context.l10n.radicals: [
          Center(
            child: DialogContentText(
              richText: context.l10n.theyAreBranchesOfTheMainCarbonChain,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: DialogContentText(
              richText: context.l10n.example,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/icons/2-methylpropane.png',
              height: 90,
              color: QuimifyColors.primary(context),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.twoMethylPropane,
            ),
          ),
        ],
        context.l10n.bondCarbon: [
          Center(
            child: SizedBox(
              width: 100,
              child: AddCarbonButton(
                height: buttonHeight,
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.thisButtonIsUsedToAddACarbonToTheChain,
            ),
          ),
        ],
        context.l10n.hydrogenate: [
          Center(
            child: SizedBox(
              width: 100,
              child: HydrogenateButton(
                height: buttonHeight,
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText:
                  context.l10n.thisButtonIsUsedToLinkSeveralHydrogensToCarbon,
            ),
          ),
        ],
        context.l10n.history: [
          Center(
            child: Container(
              width: 100,
              decoration: exampleButtonBorder,
              child: HistoryButton(
                height: buttonHeight,
                onPressed: () {},
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.thisButtonIsUsedToSeePreviousResults,
            ),
          ),
        ],
        context.l10n.undo: [
          Center(
            child: SizedBox(
              width: 100,
              child: UndoButton(
                height: buttonHeight,
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.thisButtonIsUsedToUndoTheLastChange,
            ),
          ),
        ],
      },
    );
  }
}
