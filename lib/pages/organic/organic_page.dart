import 'package:flutter/material.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/organic/naming/naming_page.dart';
import 'package:quimify_client/pages/organic/widgets/finding_formula_help_dialog.dart';
import 'package:quimify_client/pages/organic/widgets/naming_help_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class OrganicPage extends StatelessWidget {
  const OrganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuimifySectionTitle(
          title: context.l10n.fromNameToFormula,
          helpDialog: const FindingFormulaHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard.custom(
          customBody: {
            Image.asset(
              'assets/images/icons/2-chloroethylbenzene.png',
              height: 30,
              color: QuimifyColors.teal(),
            ): '2-cloroetilbenceno',
          },
          page: const FindingFormulaPage(),
        ),
        QuimifySectionTitle(
          title: context.l10n.fromFormulaToName,
          helpDialog: const NamingHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard(
          body: {
            'CHO – CN': '2-oxoetanonitrilo',
            'CH₃ – CONH₂': 'etanamida',
            'CH₃ – O – CF₃': context.l10n.methylTrifluoromethylEther,
            'CN – COOH': context.l10n.cyanomethanoicAcid,
            'CH₃ – C Ξ CH': 'prop-1-ino',
            'CH₂ = CBr₂': '1,1-dibromoeteno',
          },
          page: const NamingPage(),
        ),
      ],
    );
  }
}
