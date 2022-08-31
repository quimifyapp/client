import 'package:cliente/nomenclature/organic/naming/naming_ether_page.dart';
import 'package:cliente/nomenclature/organic/naming/naming_simple_page.dart';
import 'package:flutter/material.dart';

import '../../widgets/constants.dart';
import '../../widgets/page_app_bar.dart';
import '../widgets/menu_card.dart';
import '../widgets/section_title.dart';

class NamingPage extends StatelessWidget {
  const NamingPage({Key? key}) : super(key: key);

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
                decoration: bodyBoxDecoration,
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
                          children: const [
                            MenuCard(
                              title: 'Simple',
                              structure: 'CH₂ - CH₂(F)',
                              name: '1-fluoroetano',
                              page: NamingSimplePage(),
                            ),
                            SizedBox(height: 25),
                            MenuCard(
                              title: 'Éter',
                              structure: 'CH₃ - O - CH₃',
                              name: 'dimetiléter',
                              page: NamingEtherPage(),
                            ),
                            SizedBox(height: 25),
                            MenuCard.locked(
                              title: 'Éster',
                            ),
                            SizedBox(height: 25),
                            MenuCard.locked(
                              title: 'Aromático',
                            ),
                            SizedBox(height: 25),
                            MenuCard.locked(
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
