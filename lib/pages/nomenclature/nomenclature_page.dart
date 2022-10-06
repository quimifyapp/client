import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/pages/nomenclature/inorganic/inorganic_nomenclature_page.dart';
import 'package:cliente/pages/nomenclature/organic/finding_formula_page.dart';
import 'package:cliente/pages/nomenclature/organic/naming/naming_page.dart';
import 'package:cliente/pages/widgets/appearance/quimify_teal.dart';
import 'package:cliente/pages/widgets/bars/quimify_home_bar.dart';
import 'package:cliente/pages/widgets/menus/quimify_horizontal_menu.dart';
import 'package:cliente/pages/widgets/menus/quimify_card.dart';
import 'package:cliente/pages/widgets/objects/quimify_section_title.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:flutter/material.dart';

class NomenclaturePage extends StatelessWidget {
  NomenclaturePage({Key? key}) : super(key: key);

  final autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const QuimifyHomeBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QuimifySectionTitle(title: 'Inorgánica'),
              const SizedBox(height: 25),
              InorganicMenu(autoSizeGroup: autoSizeGroup),
              const SizedBox(height: 25),
              const QuimifySectionTitle(title: 'Orgánica'),
              const SizedBox(height: 25),
              OrganicMenu(autoSizeGroup: autoSizeGroup),
              // To keep it above navigation bar:
              const SizedBox(height: 2 * 30 + 60),
            ],
          ),
        ),
      ),
    );
  }
}

class InorganicMenu extends StatelessWidget {
  const InorganicMenu({Key? key, required this.autoSizeGroup})
      : super(key: key);

  final AutoSizeGroup autoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return QuimifyHorizontalMenu(
      cards: [
        QuimifyCard(
          width: 290,
          title: 'Formular o nombrar',
          structure: 'H₂O',
          autoSizeGroup: autoSizeGroup,
          name: 'dióxido de hidrógeno',
          page: const InorganicNomenclaturePage(),
        ),
        const QuimifyCard.locked(
          width: 290,
          title: 'Practicar',
        ),
      ],
    );
  }
}

class OrganicMenu extends StatelessWidget {
  const OrganicMenu({Key? key, required this.autoSizeGroup}) : super(key: key);

  final AutoSizeGroup autoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return QuimifyHorizontalMenu(
      cards: [
        QuimifyCard.custom(
          width: 290,
          title: 'Formular',
          customBody: Container(
            color: Theme.of(context).colorScheme.surface,
            padding:
                const EdgeInsets.only(top: 20, bottom: 15, left: 25, right: 25),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/icons/2-chloroethylbenzene.png',
                  color: quimifyTeal,
                  height: 30,
                ),
                const SizedBox(height: 12),
                Text(
                  '2-cloroetilbenceno',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          page: const FindingFormulaPage(),
        ),
        QuimifyCard(
          width: 290,
          title: 'Nombrar',
          structure: 'CH₃ - C(CH₃) = CO',
          autoSizeGroup: autoSizeGroup,
          name: '2-metilprop-1-en-1-ona',
          page: NamingPage(),
        ),
        const QuimifyCard.locked(
          width: 290,
          title: 'Practicar',
        ),
      ],
    );
  }
}
