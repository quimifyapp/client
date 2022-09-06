import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'naming/naming_ether_page.dart';
import 'naming/naming_simple_page.dart';
import '../../../constants.dart';
import '../../../widgets/page_app_bar.dart';
import '../widgets/menu_card.dart';
import '../widgets/section_title.dart';

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
                      const SectionTitle(title: 'Tipo de compuesto'),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            MenuCard(
                              title: 'Simple',
                              structure: 'CH₃ - CH₂(CH₃) - CH₃',
                              autoSizeGroup: autoSizeGroup,
                              name: '2-metilpropano',
                              page: const NamingSimplePage(),
                            ),
                            const SizedBox(height: 25),
                            MenuCard(
                              title: 'Éter',
                              structure: 'CH₃ - CH₂ - O - CH₃',
                              autoSizeGroup: autoSizeGroup,
                              name: 'etil metil éter',
                              page: const NamingEtherPage(),
                            ),
                            const SizedBox(height: 25),
                            const MenuCard.locked(
                              title: 'Éster',
                            ),
                            const SizedBox(height: 25),
                            const MenuCard.locked(
                              title: 'Aromático',
                            ),
                            const SizedBox(height: 25),
                            const MenuCard.locked(
                              title: 'Cíclico',
                            ),
                          ],
                        ),
                      ),
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
