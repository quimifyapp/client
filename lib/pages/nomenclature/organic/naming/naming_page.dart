import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/constants.dart';
import 'package:cliente/pages/nomenclature/organic/naming/open_chain/naming_ether_page.dart';
import 'package:cliente/pages/nomenclature/organic/naming/open_chain/naming_simple_page.dart';
import 'package:cliente/widgets/horizontal_cards_menu.dart';
import 'package:cliente/widgets/menu_card.dart';
import 'package:cliente/widgets/page_app_bar.dart';
import 'package:cliente/widgets/section_title.dart';
import 'package:flutter/material.dart';

class NamingPage extends StatelessWidget {
  NamingPage({Key? key}) : super(key: key);

  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const PageAppBar(title: 'Nombrar orgánico'),
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
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Cadena abierta'),
                      const SizedBox(height: 25),
                      OpenChainMenu(autoSizeGroup: autoSizeGroup),
                      const SizedBox(height: 25),
                      const SectionTitle(title: 'Cadena cerrada'),
                      const SizedBox(height: 25),
                      ClosedChainMenu(autoSizeGroup: autoSizeGroup),
                    ],
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

class OpenChainMenu extends StatelessWidget {
  const OpenChainMenu({Key? key, required this.autoSizeGroup}) : super(key: key);

  final AutoSizeGroup autoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return HorizontalCardsMenu(
      cards: [
        MenuCard(
          width: 290,
          title: 'Simple',
          structure: 'CH₃ - C(CH₃) = CH₂',
          autoSizeGroup: autoSizeGroup,
          name: '2-metilprop-1-eno',
          page: const NamingSimplePage(),
        ),
        MenuCard(
          width: 290,
          title: 'Éter',
          structure: 'CH₃ - O - CH₂(F)',
          autoSizeGroup: autoSizeGroup,
          name: 'fluorometil metil éter',
          page: const NamingEtherPage(),
        ),
        const MenuCard.locked(
          width: 290,
          title: 'Éster',
        ),
      ],
    );
  }
}

class ClosedChainMenu extends StatelessWidget {
  const ClosedChainMenu({Key? key, required this.autoSizeGroup}) : super(key: key);

  final AutoSizeGroup autoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return const HorizontalCardsMenu(
      cards: [
        MenuCard.locked(
          width: 290,
          title: 'Aromático',
        ),
        MenuCard.locked(
          width: 290,
          title: 'Cíclico',
        ),
      ],
    );
  }
}
