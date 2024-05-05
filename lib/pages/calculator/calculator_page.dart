import 'package:flutter/material.dart';
import 'package:quimify_client/pages/calculator/balancer/balancer_page.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/calculator/widgets/calculator_help_dialog.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        QuimifySectionTitle(
          title: 'Masa molecular',
          helpDialog: CalculatorHelpDialog(),
        ),
        SizedBox(height: 15),
        QuimifyCard(
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
        QuimifySectionTitle(
          title: 'Ajustar reacciones',
          helpDialog: comingSoonDialog,
        ),
        SizedBox(height: 15),
        QuimifyCard(
          body: {
            '2H + O ⟶ H₃O': '6H + 2O ⟶ 2(H₃O)',
            'Fe₂O₃ + C ⟶ Fe + CO₂': '2(Fe₂O₃) + 3C ⟶ 4Fe + 3(CO₂)',
            'Cl + 2OP ⟶ Cl₂O + P': '4Cl + 2(OP) ⟶ 2(Cl₂O) + 2P',
          },
          page: BalancerPage(),
        ),
      ],
    );
  }
}
