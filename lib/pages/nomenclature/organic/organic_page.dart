import 'package:quimify_client/pages/nomenclature/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/naming_open_chain_page.dart';
import 'package:quimify_client/pages/nomenclature/widgets/organic_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/menus/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';

class OrganicPage extends StatelessWidget {
  const OrganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuimifySectionTitle(
            title: 'Orgánica',
            dialog: OrganicHelpDialog(),
          ),
          const SizedBox(height: 15),
          QuimifyCard.custom(
            customTitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                'assets/images/icons/2-chloroethylbenzene.png',
                color: quimifyTeal,
                height: 28,
              ),
            ),
            subtitle: '2-cloroetilbenceno',
            page: const FindingFormulaPage(),
          ),
          const QuimifyCard(
            title: 'CH₂ = CH(OH)',
            subtitle: 'etenol',
            page: NamingOpenChainPage(),
          ),
          const QuimifySectionTitle(
            title: 'Practicar',
            dialog: OrganicHelpDialog(),
          ),
          const SizedBox(height: 15),
          QuimifyCard.comingSoon(
            customTitle: Container(),
          ),
        ],
      ),
    );
  }
}
