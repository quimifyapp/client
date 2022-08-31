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
            PageAppBar(title: 'Nombrar orgánico'),
            // Body:
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        SectionTitle(title: 'Tipo de compuesto'),
                        SizedBox(height: 25),
                        Container(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Wrap(
                            direction: Axis.vertical,
                            spacing: 25,
                            children: [
                              MenuCard(
                                title: 'Simple',
                                structure: 'CH₂ - CH₂(F)',
                                name: '1-fluoroetano',
                                page: NamingSimplePage(),
                              ),
                              MenuCard(
                                title: 'Éter',
                                structure: 'CH₃ - O - CH₃',
                                name: 'dimetiléter',
                                page: NamingEtherPage(),
                              ),
                              MenuCard.locked(
                                title: 'Éster',
                              ),
                              MenuCard.locked(
                                title: 'Aromático',
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
