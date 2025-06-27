import 'package:flutter/material.dart';
import 'package:quimify_client/pages/calculator/equation/equation_page.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/calculator/widgets/equation_help_dialog.dart';
import 'package:quimify_client/pages/calculator/widgets/molecular_mass_help_dialog.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuimifySectionTitle(
          title: context.l10n.molecularMasses,
          helpDialog: const MolecularMassHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard(
          body: {
            'Fe₂O₃': '159.68 ${context.l10n.gMole}',
            'C₅H₆O₂': '110.10 ${context.l10n.gMole}',
            'NaCl': '58.35 ${context.l10n.gMole}',
            'H₂S': '34.08 ${context.l10n.gMole}',
            'CH₃CN': '41.05 ${context.l10n.gMole}',
            'SiH₄': '32.12 ${context.l10n.gMole}',
          },
          page: MolecularMassPage(),
        ),
        QuimifySectionTitle(
          title: context.l10n.balanceReactions,
          helpDialog: const EquationHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard(
          paidFeature: true,
          body: {
            toEquation('H₂ + O₂', 'H₂O'): toEquation('2H₂ + O₂', '2H₂O'),
            toEquation('NH₃', 'N₂ + H₂'): toEquation('2NH₃', 'N₂ + 3H₂'),
            toEquation('Fe + O₂', 'Fe₂O₃'): toEquation('4Fe + 3O₂', '2Fe₂O₃'),
          },
          page: const EquationPage(),
        ),
      ],
    );
  }
}
