import 'package:quimify_client/pages/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/organic/naming/open_chain/naming_open_chain_page.dart';
import 'package:quimify_client/pages/organic/widgets/finding_formula_help_dialog.dart';
import 'package:quimify_client/pages/organic/widgets/naming_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';

class OrganicPage extends StatelessWidget {
  const OrganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QuimifySectionTitle(
          title: 'Formular',
          dialog: FindingFormulaHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard.custom(
          customTitle: Image.asset(
            'assets/images/icons/2-chloroethylbenzene.png',
            height: 30,
            color: quimifyTeal,
          ),
          subtitle: '2-cloroetilbenceno',
          page: const FindingFormulaPage(),
        ),
        const QuimifySectionTitle(
          title: 'Nombrar',
          dialog: NamingHelpDialog(),
        ),
        const SizedBox(height: 15),
        const QuimifyCard(
          title: 'CH₂ = CH(OH)',
          subtitle: 'etenol',
          page: NamingOpenChainPage(),
        ),
        const QuimifySectionTitle(
          title: 'Practicar',
          dialog: quimifyComingSoonDialog,
        ),
        const SizedBox(height: 15),
        const QuimifyCard.comingSoon(
          customTitle: Icon(
            Icons.edit_note_rounded,
            size: 36,
            color: quimifyTeal,
          ),
        ),
      ],
    );
  }
}
