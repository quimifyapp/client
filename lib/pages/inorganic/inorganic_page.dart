import 'package:quimify_client/pages/inorganic/naming_and_finding_formula_page.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';

class InorganicPage extends StatelessWidget {
  const InorganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        QuimifySectionTitle(
          title: 'Formular y nombrar',
          dialog: InorganicHelpDialog(),
        ),
        SizedBox(height: 15),
        QuimifyCard(
          title: 'H₂O',
          subtitle: 'óxido de hidrógeno',
          page: NamingAndFindingFormulaPage(),
        ),
        QuimifySectionTitle(
          title: 'Practicar',
          dialog: quimifyComingSoonDialog,
        ),
        SizedBox(height: 15),
        QuimifyCard.comingSoon(
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
