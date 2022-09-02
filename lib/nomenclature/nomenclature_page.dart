import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/nomenclature/inorganic/finding_formula_or_naming_page.dart';
import 'package:cliente/nomenclature/organic/finding_formula_page.dart';
import 'package:cliente/nomenclature/widgets/menu_card.dart';
import 'package:cliente/nomenclature/widgets/section_title.dart';
import 'package:flutter/material.dart';

import 'package:cliente/widgets/home_app_bar.dart';
import 'package:cliente/widgets/constants.dart';

import 'organic/naming_page.dart';

class NomenclaturePage extends StatelessWidget {
  NomenclaturePage({Key? key}) : super(key: key);

  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            HomeAppBar(
              title: Image.asset(
                'assets/images/icons/branding_slim.png',
                height: 17,
                color: Colors.white,
              ),
            ),
            // Body:
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
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
          page: const FindingFormulaOrNamingPage(),
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
  OrganicMenu({Key? key, required this.autoSizeGroup}) : super(key: key);

  final AutoSizeGroup autoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return HorizontalCardsMenu(
      cards: [
        MenuCard.custom(
          width: 290,
          title: 'Formular',
          customBody: Container(
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
                const Text(
                  '3-cloropropilbenceno',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          page: const FindingFormulaPage(),
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

class HorizontalCardsMenu extends StatelessWidget {
  const HorizontalCardsMenu({Key? key, required this.cards}) : super(key: key);

  final List<MenuCard> cards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Wrap(
          spacing: 15,
          children: cards,
        ),
      ),
    );
  }
}
