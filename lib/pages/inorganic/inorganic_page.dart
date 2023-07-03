import 'package:flutter/material.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/inorganic/nomenclature_page.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';

class InorganicPage extends StatelessWidget {
  const InorganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        QuimifySectionTitle(
          title: 'Formular y nombrar',
          helpDialog: InorganicHelpDialog(),
        ),
        SizedBox(height: 15),
        QuimifyCard(
          body: {
            'H₂O': 'óxido de hidrógeno',
            'AuF₃': 'trifluoruro de oro',
            'HCl': 'ácido clorhídrico',
            'Fe₂S₃': 'sulfuro de hierro(III)',
            'PbBr₂': 'dibromuro de plomo',
            'H₂SO₃': 'ácido sulfuroso',
          },
          page: NamingAndFindingFormulaPage(),
        ),
        QuimifySectionTitle(
          title: 'Practicar',
          helpDialog: quimifyComingSoonDialog,
        ),
        SizedBox(height: 15),
        QuimifyCard.comingSoon(
          comingSoonBody: Icon(
            Icons.edit_note_rounded,
            size: 36,
            color: quimifyTeal,
          ),
        ),
        SizedBox(height: 5), // + 15 from cards = 20
      ],
    );
  }
}
