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
      children: [
        const QuimifySectionTitle(
          title: 'Masa molecular',
          dialog: CalculatorHelpDialog(),
        ),
        const SizedBox(height: 15),
        if (false) // TODO
          const QuimifyCard(
            title: 'NaCl',
            subtitle: '17.42 g/mol',
            page: MolecularMassPage(),
          ),
        QuimifyCard.custom(
          customTitle: Image.asset(
            'assets/images/icons/scale.png',
            height: 40,
            color: quimifyTeal,
          ),
          page: const MolecularMassPage(),
        ),
        const QuimifySectionTitle(
          title: 'Ajustar reacciones',
          dialog: quimifyComingSoonDialog,
        ),
        const SizedBox(height: 15),
        const QuimifyCard.comingSoon(
          customTitle: Text(
            '⇄',
            style: TextStyle(
              height: 0.9,
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: quimifyTeal,
            ),
          ),
        ),
      ],
    );
  }
}
