import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/pages/nomenclature/widgets/horizontal_cards_menu.dart';
import 'package:flutter/material.dart';

import 'package:cliente/widgets/home_app_bar.dart';
import 'package:cliente/constants.dart';

import 'organic/finding_formula_page.dart';
import 'widgets/menu_card.dart';
import 'widgets/section_title.dart';
import 'inorganic/inorganic_nomenclature.dart';
import 'organic/naming_page.dart';

class NomenclaturePage extends StatelessWidget {
  NomenclaturePage({Key? key}) : super(key: key);

  final autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const HomeAppBar(),
            // Body:
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Inorgánica'),
                        const SizedBox(height: 25),
                        InorganicMenu(autoSizeGroup: autoSizeGroup),
                        const SizedBox(height: 40),
                        const SectionTitle(title: 'Orgánica'),
                        const SizedBox(height: 25),
                        OrganicMenu(autoSizeGroup: autoSizeGroup),
                        // To keep it above navigation bar:
                        const SizedBox(height: 50 + 60 + 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InorganicMenu extends StatelessWidget {
  InorganicMenu({Key? key, required this.autoSizeGroup}) : super(key: key);

  final AutoSizeGroup autoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return HorizontalCardsMenu(
      cards: [
        MenuCard(
          width: 290,
          title: 'Formular o nombrar',
          structure: 'H₂O',
          autoSizeGroup: autoSizeGroup,
          name: 'dióxido de hidrógeno',
          page: const InorganicNomenclaturePage(),
        ),
        const MenuCard.locked(
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
    return HorizontalCardsMenu(
      cards: [
        MenuCard.custom(
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
                  'assets/images/icons/3-chloropropylbenzene.png',
                  color: quimifyTeal,
                  height: 30,
                ),
                const SizedBox(height: 12),
                Text(
                  '3-cloropropilbenceno',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          page: FindingFormulaPage(),
        ),
        MenuCard(
          width: 290,
          title: 'Nombrar',
          structure: 'CH₂ - CH₂(F)',
          autoSizeGroup: autoSizeGroup,
          name: '1-fluoroetano',
          page: NamingPage(),
        ),
        const MenuCard.locked(
          width: 290,
          title: 'Practicar',
        ),
      ],
    );
  }
}
