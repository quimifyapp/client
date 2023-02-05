import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/calculator/widgets/calculator_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
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
          helpDialog: quimifyComingSoonDialog,
        ),
        SizedBox(height: 15),
        QuimifyCard.comingSoon(
          comingSoonBody: Text(
            '⇄',
            style: TextStyle(
              height: 0.9, // TODO iOS?
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: quimifyTeal,
            ),
          ),
        ),
        SizedBox(height: 5), // + 15 from cards = 20
      ],
    );
  }
}
