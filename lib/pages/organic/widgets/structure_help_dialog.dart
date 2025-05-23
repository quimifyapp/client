import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class StructureHelpDialog extends StatelessWidget {
  const StructureHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.structure: [
          Center(
            child: DialogContentText(
              richText: context.l10n.everyCarbonIsAVertexTheHydrogensAreOmitted,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/butane-diagram.png',
                height: 130,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: '(${context.l10n.butane})',
            ),
          ),
        ],
        context.l10n.singleBond: [
          Center(
            child: DialogContentText(
              richText: context.l10n.itIsRepresentedWithOneLine,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/butane.png',
                height: 50,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          Center(
            child: DialogContentText(
              richText: '(${context.l10n.butane})',
            ),
          ),
        ],
        context.l10n.doubleBond: [
          Center(
            child: DialogContentText(
              richText: context.l10n.itIsRepresentedWithTwoLines,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/but-2-ene.png',
                height: 50,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: '(but-2-eno)',
            ),
          ),
        ],
        context.l10n.tripleBond: [
          Center(
            child: DialogContentText(
              richText: context.l10n.itIsRepresentedWithThreeLines,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/but-2-yne.png',
                height: 50,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: '(but-2-ino)',
            ),
          ),
        ],
      },
    );
  }
}
