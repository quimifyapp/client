import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/pages/nomenclature/organic/naming/open_chain/naming_open_chain_page.dart';
import 'package:cliente/pages/widgets/menu_card.dart';
import 'package:cliente/pages/widgets/page_app_bar.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:cliente/pages/widgets/section_title.dart';
import 'package:flutter/material.dart';

class NamingPage extends StatelessWidget {
  NamingPage({Key? key}) : super(key: key);

  static const double _cardVerticalPadding = 20;
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const PageAppBar(title: 'Nombrar orgánico'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            const SectionTitle(title: 'Tipo de orgánico'),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  MenuCard(
                    title: 'Cadena abierta',
                    structure: 'CH₃ - O - CH₂(F)',
                    // 'CH₃ - C(CH₃) = CH₂',
                    autoSizeGroup: _autoSizeGroup,
                    name: 'fluorometil metil éter',
                    //'2-metilprop-1-eno',
                    page: const NamingOpenChainPage(),
                  ),
                  const SizedBox(height: _cardVerticalPadding),
                  const MenuCard.locked(
                    title: 'Éster',
                  ),
                  const SizedBox(height: _cardVerticalPadding),
                  const MenuCard.locked(
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
