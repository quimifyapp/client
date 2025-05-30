import 'package:flutter/material.dart';
import 'package:quimify_client/pages/calculator/equation/equation_page.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/calculator/widgets/equation_help_dialog.dart';
import 'package:quimify_client/pages/calculator/widgets/molecular_mass_help_dialog.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/text.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QuimifySectionTitle(
          title: 'Masas moleculares',
          helpDialog: MolecularMassHelpDialog(),
        ),
        const SizedBox(height: 15),
        const QuimifyCard(
          body: {
            'Fe₂O₃': '159.68 g/mol',
            'C₅H₆O₂': '110.10 g/mol',
            'NaCl': '58.35 g/mol',
            'H₂S': '34.08 g/mol',
            'CH₃CN': '41.05 g/mol',
            'SiH₄': '32.12 g/mol',
          },
          page: MolecularMassPage(),
        ),
        const QuimifySectionTitle(
          title: 'Balancear reacciones',
          helpDialog: EquationHelpDialog(),
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
