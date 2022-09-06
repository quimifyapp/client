import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../widgets/home_app_bar.dart';
import '../nomenclature/widgets/menu_card.dart';
import '../nomenclature/widgets/section_title.dart';


class CalculatorPage extends StatelessWidget {
  CalculatorPage({Key? key}) : super(key: key);

  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

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
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Calculadora'),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            MenuCard(
                              title: 'Masa molecular',
                              structure: 'H₂SO₄',
                              autoSizeGroup: autoSizeGroup,
                              name: '97.967 g/mol',
                              page: const MolecularMassPage(),
                            ),
                            const SizedBox(height: 30),
                            const MenuCard.locked(
                              title: 'Ajustar reacción',
                            ),
                            // To keep it above navigation bar:
                            const SizedBox(height: 50 + 60),
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
