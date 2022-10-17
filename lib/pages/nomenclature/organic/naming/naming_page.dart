import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/naming_open_chain_page.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/widgets/organic_naming_help_dialog.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/menus/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:flutter/material.dart';

class NamingPage extends StatelessWidget {
  NamingPage({Key? key}) : super(key: key);

  static const double _cardVerticalPadding = 20;
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const QuimifyPageBar(title: 'Nombrar orgánico'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            const QuimifySectionTitle(
              title: 'Tipo de orgánico',
              dialog: OrganicNamingHelpDialog(),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  QuimifyCard(
                    title: 'Cadena abierta',
                    structure: 'CH₃ – O – CH₂(F)',
                    autoSizeGroup: _autoSizeGroup,
                    name: 'fluorometil metil éter',
                    page: const NamingOpenChainPage(),
                  ),
                  const SizedBox(height: _cardVerticalPadding),
                  const QuimifyCard.comingSoon(
                    title: 'Éster',
                  ),
                  const SizedBox(height: _cardVerticalPadding),
                  const QuimifyCard.comingSoon(
                    title: 'Cíclico',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
