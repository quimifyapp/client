import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class MolecularMassInputHelpDialog extends StatelessWidget {
  const MolecularMassInputHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        context.l10n.moleConcept: [
          Center(
            child: DialogContentText(
              richText: context.l10n
                  .aMoleRepresentsOfMatterThisNumberIsKnownAsAvogadroConstant,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n.aMoleOfCarsAre,
            ),
          ),
        ],
        context.l10n.items: [
          Center(
            child: DialogContentText(
              richText: context.l10n
                  .theMolecularMassOfAnAtomIsTheMassInGramsOfOneMolOfThatAtom,
            ),
          ),
          DialogContentText(
            richText: context.l10n.examples,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
                ),
                children: [
                  TextSpan(text: 'H (${context.l10n.hydrogen})   ➔   '),
                  const TextSpan(
                    text: '1.01',
                    style: TextStyle(color: Colors.blue),
                  ),
                  const TextSpan(text: ' g/mol'),
                ],
              ),
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 16,
                  fontFamily: 'CeraPro',
                ),
                children: [
                  TextSpan(text: 'O (${context.l10n.oxygen})   ➔   '),
                  const TextSpan(
                    text: '15.99',
                    style: TextStyle(color: Colors.red),
                  ),
                  const TextSpan(text: ' g/mol'),
                ],
              ),
            ),
          ),
        ],
        context.l10n.molecularMass: [
          Center(
            child: DialogContentText(
              richText: context.l10n
                  .theMolecularMassOfACompoundIsTheSumOfTheMassesOfItsAtoms,
            ),
          ),
          DialogContentText(
            richText: context.l10n.example,
          ),
          Center(
            child: DialogContentText(
              richText: context.l10n
                  .waterHas2HydrogenAtomsAnd1OxygenAtomInItsMoleculeItsMolecularMassIs,
            ),
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
                  TextSpan(text: '2 x '),
                  TextSpan(
                    text: '1.01',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: ' + 1 x '),
                  TextSpan(
                    text: '15.99',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(text: ' = 18.00 g/mol'),
                ],
              ),
            ),
          ),
        ],
      },
    );
  }
}
