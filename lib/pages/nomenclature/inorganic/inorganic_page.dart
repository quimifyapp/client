import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/pages/nomenclature/inorganic/inorganic_nomenclature_page.dart';
import 'package:quimify_client/pages/nomenclature/widgets/inorganic_help_dialog.dart';
import 'package:quimify_client/pages/widgets/menus/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';

class InorganicPage extends StatelessWidget {
  InorganicPage({Key? key}) : super(key: key);

  final double cardWidth = 220;
  final autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuimifySectionTitle(
            title: 'Inorgánica',
            dialog: InorganicHelpDialog(),
          ),
          const SizedBox(height: 25),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Wrap(
                spacing: 15,
                children: [
                  QuimifyCard(
                    width: cardWidth,
                    title: 'Formular y nombrar',
                    structure: 'H₂O',
                    autoSizeGroup: autoSizeGroup,
                    name: 'óxido de hidrógeno',
                    page: const InorganicNomenclaturePage(),
                  ),
                  QuimifyCard.comingSoon(
                    width: cardWidth,
                    title: 'Practicar',
                  ),
                ],
              ),
            ),
          ),
          // To keep it above navigation bar:
          const SizedBox(height: 2 * 30 + 60), // TODO
        ],
      ),
    );
  }
}
