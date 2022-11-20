import 'package:quimify_client/pages/nomenclature/inorganic/inorganic_nomenclature_page.dart';
import 'package:quimify_client/pages/nomenclature/widgets/inorganic_help_dialog.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/menus/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';

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
          page: InorganicNomenclaturePage(),
        ),
        QuimifySectionTitle(
          title: 'Practicar',
          dialog: InorganicHelpDialog(),
        ),
        SizedBox(height: 15),
        QuimifyCard.comingSoon(
          customTitle: Icon(
            Icons.edit_note_rounded,
            size: 30,
            color: quimifyTeal,
          ),
        ),
      ],
    );
  }
}
