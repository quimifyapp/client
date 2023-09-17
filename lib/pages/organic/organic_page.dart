import 'package:flutter/material.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/organic/naming/naming_page.dart';
import 'package:quimify_client/pages/organic/widgets/finding_formula_help_dialog.dart';
import 'package:quimify_client/pages/organic/widgets/naming_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_coming_soon_dialog.dart';

class OrganicPage extends StatelessWidget {
  const OrganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QuimifySectionTitle(
          title: 'Formular',
          helpDialog: FindingFormulaHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard.custom(
          customBody: {
            Image.asset(
              'assets/images/icons/2-chloroethylbenzene.png',
              height: 30,
              color: quimifyTeal,
            ): '2-cloroetilbenceno',
          },
          page: const FindingFormulaPage(),
        ),
        const QuimifySectionTitle(
          title: 'Nombrar',
          helpDialog: NamingHelpDialog(),
        ),
        const SizedBox(height: 15),
        const QuimifyCard(
          body: {
            'CHO – CN': '2-oxoetanonitrilo',
            'CH₃ – CONH₂': 'etanamida',
            'CH₃ – O – CF₃': 'metil trifluorometil éter',
            'CN – COOH': 'ácido cianometanoico',
            'CH₃ – C Ξ CH': 'prop-1-ino',
            'CH₂ = CBr₂': '1,1-dibromoeteno',
          },
          page: NamingPage(),
        ),
        const QuimifySectionTitle(
          title: 'Practicar',
          helpDialog: quimifyComingSoonDialog,
        ),
        const SizedBox(height: 15),
        const QuimifyCard.comingSoon(
          comingSoonBody: Icon(
            Icons.edit_note_rounded,
            size: 36,
            color: quimifyTeal,
          ),
        ),
      ],
    );
  }
}
